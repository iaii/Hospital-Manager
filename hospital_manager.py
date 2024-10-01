import numpy as np
import pandas as pd
import streamlit as st
# from datetime import datetime
import datetime
import random
import psycopg2
from psycopg2 import OperationalError

import mysql.connector
from mysql.connector import Error
from sqlalchemy import create_engine

conn = mysql.connector.connect(host="localhost",
    user="root", password="CPSC408!", auth_plugin='mysql_native_password',
    database="HospitalRecordsApp")

mysql_host = "localhost"
mysql_user = "root"
mysql_password = "CPSC408!"
mysql_database = "HospitalRecordsApp"

def get_mysql_connection():
    try:
        conn = mysql.connector.connect(
            host=mysql_host,
            user=mysql_user,
            password=mysql_password,
            database=mysql_database
        )
        if conn.is_connected():
            return conn
    except Error as e:
        st.error(f"Error while connecting to MySQL: {e}")
        return None

if 'conn' not in st.session_state:
    st.session_state.conn = get_mysql_connection()

connection_string = f'mysql+mysqlconnector://{mysql_user}:{mysql_password}@{mysql_host}/{mysql_database}'
engine = create_engine(connection_string)

conn = mysql.connector.connect(
    host=mysql_host,
    user=mysql_user,
    password=mysql_password,
    database=mysql_database
)

cur_obj = conn.cursor()

if 'user_id' not in st.session_state:
    st.session_state.user_id = 2
    st.session_state.user = 'PersonL'
    st.session_state.user_password = 'L'
    st.session_state.name = 'Person'

def visit_history():
    st.subheader("Visit History")
    
    if st.session_state.user:
        query = '''
        SELECT Visits.Visit_ID AS VisitID, 
            Visits.Date AS Date, 
            Doctors.Last_Name AS Doctor_LastName,
            Hospitals.Hospital_Name AS Hospital_Name,
            Visits.Purpose AS Visit_Purpose, 
            Visits.Visit_Completed
        FROM Visits 
        INNER JOIN Doctors
            ON Visits.Doctor_ID = Doctors.Doctor_ID
        INNER JOIN Hospitals
            ON Doctors.Primary_Hospital_ID = Hospitals.Hospital_ID
        WHERE Patient_ID = %s
        AND Visit_Completed = 1;
        '''
        
        df = pd.read_sql(query, conn, params=(st.session_state.user_id,))
        st.subheader(st.session_state.user)
        if len(df) < 1:
            st.warning(f'No visit history for {st.session_state.user}.')
        else:
            st.dataframe(df, hide_index=True)

def invoices():
    st.subheader("Invoices")
    options = ["Select", "All Invoices", "Invoices By Date"]
    invoice_options = st.selectbox("Invoice Options", options)
    
    if invoice_options == "-":
        pass
    elif st.session_state.user and invoice_options == 'All Invoices':

        query = '''
            SELECT Invoices.Invoice_ID AS InvoiceID,
            Invoices.Date,
            Invoices.CoPay_Amt AS CoPay_Amount,
            Invoices.Purpose AS Visit_Purpose,
            Hospitals.Hospital_Name,
            Hospitals.Address,
            Doctors.Last_Name AS Doctor_Name
            FROM Invoices 
            INNER JOIN Hospitals
                ON Invoices.Hospital_ID = Hospitals.Hospital_ID
            INNER JOIN Doctors
                ON Hospitals.Hospital_ID = Doctors.Primary_Hospital_ID
            WHERE Patient_ID = %s;
        '''
        
        df = pd.read_sql(query, conn, params=(st.session_state.user_id,))

        print("user id")
        print(st.session_state.user_id)
        print(df)
       
        st.subheader(st.session_state.user)
        if len(df) < 1:
            st.warning(f'No invoice history for {st.session_state.user}.')
        else:
            st.dataframe(df, hide_index=True)
    elif st.session_state.user and invoice_options == 'Invoices By Date':
        selected_date = st.date_input('Select Date')
        stored_date = selected_date.strftime("%Y-%m-%d")
        
        query = '''
            SELECT * 
            FROM view_patient_invoices
            WHERE Patient_ID = %s;
            AND Date = %s
        '''
        
        df = pd.read_sql(query, engine, params=(st.session_state.user_id, stored_date))
        st.subheader(f'{st.session_state.user}, {stored_date}')
        
        print(df)
        if len(df) < 1:
            st.warning(f'No invoices exist for {st.session_state.user} on {stored_date}.')
        else:
            st.dataframe(df, hide_index=True)

        csv = df.to_csv(index=False)
        st.download_button(
            label="Download invoices.csv",
            data=csv,
            file_name=f'invoices.csv',
            mime='text/csv')

def schedule_appointment():
    specialty = st.text_input('Doctor Specialty/Subspecialty:')

    query = '''
    SELECT Doctors.Doctor_ID, CONCAT(first_name, ' ', last_name) AS doctor_name, patient_count
    FROM (
        SELECT primary_doctor_id AS doctor_id, COUNT(patient_id) AS patient_count
        FROM patients
        GROUP BY primary_doctor_id
    ) AS doctor_patient_counts
    INNER JOIN doctors ON doctors.doctor_id = doctor_patient_counts.doctor_id
    WHERE patient_count > (
        SELECT AVG(patient_count)
        FROM (
            SELECT COUNT(patient_id) AS patient_count
            FROM patients
            GROUP BY primary_doctor_id
        ) AS avg_patient_counts
    ) AND (Doctors.Specialty = %s OR Doctors.Sub_Specialty = %s);
    '''
    if specialty:
        df = pd.read_sql(query, conn, params=(specialty, specialty))
        if len(df) < 1:
            st.warning(f'No doctors with "{specialty}" specialty/subspecialty.')
        else:
            st.dataframe(df, hide_index=True)

            selected_doctor_id = st.text_input('Please enter the doctor id of the doctor you want to visit:')

            if selected_doctor_id:
                query = '''
                SELECT *
                FROM Doctors 
                WHERE Doctor_ID = %s
                '''
                df = pd.read_sql(query, conn, params=(selected_doctor_id,))
                if len(df) < 1:
                    st.warning(f'No doctors with "{selected_doctor_id}" doctor id.')
                else:
                    st.dataframe(df, hide_index=True)
                    
                    selected_date = st.date_input('Select Date')
                    stored_date = selected_date.strftime("%Y-%m-%d %H:%M:%S")

                    query = '''
                    SELECT Date
                    FROM Visits
                    WHERE Doctor_ID = %s
                    AND DATE(Date) = %s
                    '''

                    existing_appointment_for_doctor_at_time = pd.read_sql(query, conn, params=(selected_doctor_id, stored_date))

                    if not existing_appointment_for_doctor_at_time.empty:
                        appointment_count = len(existing_appointment_for_doctor_at_time)
                        if appointment_count > 4:
                            st.write("Doctor is Fully Booked for that Day. No available slots for this date.")
                        else:
                            book_appointment(selected_doctor_id, stored_date, existing_appointment_for_doctor_at_time)
                    else:
                        book_appointment(selected_doctor_id, stored_date, existing_appointment_for_doctor_at_time)

def book_appointment(selected_doctor_id, selected_date, existing_appointment_for_doctor_at_time):
    st.write("Appointments available.")

    if not existing_appointment_for_doctor_at_time.empty:
        booked_datetimes = [pd.Timestamp(time['Date']).to_pydatetime() for index, time in existing_appointment_for_doctor_at_time.iterrows()]
    else:
        booked_datetimes = []

    if isinstance(selected_date, str):
        selected_date = datetime.datetime.strptime(selected_date, "%Y-%m-%d %H:%M:%S").date()

    start_time = datetime.datetime.combine(selected_date, datetime.time(8, 0))
    end_time = datetime.datetime.combine(selected_date, datetime.time(17, 0))
    all_times = [start_time + datetime.timedelta(minutes=30 * x) for x in range((end_time - start_time).seconds // 1800)]

    available_times = [time for time in all_times if time not in booked_datetimes]

    if not available_times:
        st.write("No available slots for this date.")
    else:
        time_options = {slot.strftime('%H:%M'): slot for slot in available_times}
        selected_time = st.selectbox("Select an available time slot", options=list(time_options.keys()))
        st.write("You selected:", selected_time, selected_date)

        purpose = st.text_input("What is the purpose of your visit?")

        if st.button('Book appointment!'):
            conn = get_mysql_connection()
            cursor = conn.cursor()

            try:
                conn.start_transaction()

                query = '''
                SELECT MAX(Visit_ID) AS MaxVisitID
                FROM Visits;
                '''
                cursor.execute(query)
                result = cursor.fetchone()
                new_visit_id = result[0] + 1 if result[0] is not None else 1

                selected_time = datetime.datetime.strptime(selected_time, "%H:%M").time()
                visit_date_time = datetime.datetime.combine(selected_date, selected_time)

                insert_query = '''
                INSERT INTO Visits (Visit_ID, Date, Patient_ID, Doctor_ID, Purpose, Visit_Completed)
                VALUES (%s, %s, %s, %s, %s, %s)
                '''
                cursor.execute(insert_query, (new_visit_id, visit_date_time, st.session_state.user_id, selected_doctor_id, purpose, 0))

                conn.commit()
                st.write('Appointment successfully scheduled!')

            except mysql.connector.Error as err:
                conn.rollback()
                st.error(f'An error occurred when booking your appointment: {err}')
                st.error(f'SQL Error Code: {err.errno}, SQL Error Message: {err.msg}')
                st.error(f'SQL State: {err.sqlstate}')

            finally:
                cursor.close()
                conn.close()

def hospital_list():
    st.title("Hospitals") 
    st.text('Hospitals in Each Region')
    
    query = '''
    SELECT Region, COUNT(Hospital_ID) AS HospitalsInRegion
    FROM Hospitals 
    GROUP BY Region
    '''
    
    df = pd.read_sql(query, conn)
    
    if len(df) < 1:
        st.warning(f'No hospitals.')
    else:
        st.dataframe(df, hide_index=True)
    
    st.text('All Hospitals Information')
    query = '''
    SELECT *
    FROM Hospitals 
    '''
    
    df = pd.read_sql(query, conn)
    
    if len(df) < 1:
        st.warning(f'No hospitals.')
    else:
        st.dataframe(df, hide_index=True)

    csv = df.to_csv(index=False)
    st.download_button(
        label="Download hospitals.csv",
        data=csv,
        file_name=f'hospitals.csv',
        mime='text/csv')
        
def account_settings():
    if st.session_state.user:
        st.subheader("Update your email address")
        email = st.text_input('Email address:')
        if st.button('Update'):
            st.success(f'Thank you for submitting your email: {email}')
            try:
                query = '''
                UPDATE Patients
                SET Email = %s
                WHERE Patient_ID = %s
                '''
                
                cur_obj.execute(query, (email, st.session_state.user_id))
                conn.commit()
                st.text('Success!')

                query = '''
                    SELECT *
                    FROM Patients
                    WHERE Patient_ID = %s
                '''
                df = pd.read_sql(query, conn, params=(st.session_state.user_id,))
                if len(df) < 1:
                    st.warning("Unable to update user info ")
                else:
                    st.dataframe(df, hide_index=True)

            except Error as e:
                st.warning('Error updating email. Character limit reached.') 
       
        st.subheader("Deactivate your account")
        del_user = st.text_input('Username (for deletion):')
        del_password = st.text_input('Password (for deletion):')      
        if st.button('Deactivate Account'):
            try:
                query = '''
                SELECT *
                FROM Patients
                WHERE Username = %s
                AND Password = %s
                '''
                
                cur_obj.execute(query, (del_user, del_password))
                result = cur_obj.fetchone()
                
                if result:
                    st.success(f'Deleting account: {del_user}') 
                    query = '''
                    UPDATE Patients
                    SET Is_Deleted = 1
                    WHERE Username = %s
                    AND Password = %s
                    '''
                    
                    cur_obj.execute(query, (del_user, del_password))
                    conn.commit()
                    
                    st.warning('Account Deleted.')
                else:
                    st.warning('Incorrect username or password.')
            except Error as e:
                st.warning('Error updating email. Character limit reached.')

st.title('HospitalApp')

options = ["Home", "Visit History", "Invoices", "Hospitals", "Schedule Appointment", "Account Settings"]
selected_page = st.sidebar.selectbox("Patient Options", options)

if selected_page == "Home":
    st.subheader('Login:') 
    user_entry = st.text_input('Patient Username:')
    pass_entry = st.text_input('Password:', type='password')

    if st.button('Submit'):
        query = '''
        SELECT Patient_ID, First_Name, Username, Is_Deleted
        FROM Patients 
        WHERE Username = %s
        AND Password = %s;
        '''
        
        cur_obj.execute(query, (user_entry, pass_entry))
        result = cur_obj.fetchone()
        
        if result:
            user_id, name, user, deleted = result
            if deleted == 1:
                st.warning('Incorrect username or password.')
                st.session_state.user_id = 1
                st.session_state.user = 'PersonK'
                st.session_state.user_password = 'K'
                st.session_state.name = 'Person'
            else:
                st.session_state.user_id = user_id
                st.session_state.user = user
                st.session_state.user_password = pass_entry
                st.session_state.name = name
                st.write(f'Welcome, {st.session_state.user}!')
        else:
            st.warning('Incorrect username or password.')
    
    st.subheader('Or Create a New Account:')                      
    new_username = st.text_input('Username:')
    new_password = st.text_input('Password.:', type='password')
    new_email = st.text_input('Email:')
    new_phone = st.text_input('Phone Number:')
    if st.button('Create New Account'):
        create_acc = True
        if new_username == "":
            st.warning('Username Required.')
            create_acc = False
        if new_password == "":
            st.warning('Password Required.')
            create_acc = False
        if new_email == "":
            st.warning('Email Required.')
            create_acc = False
        if new_phone == "":
            st.warning('Phone Number Required.')  
            create_acc = False 
        
        if create_acc == True:
            query = '''
            SELECT *
            FROM Patients
            WHERE Username = %s
            OR Email = %s
            '''
            
            cur_obj.execute(query, (new_username, new_email))
            result = cur_obj.fetchone()
            
            if result:
                st.warning('Account already exists.') 
            
            else:
                query = """INSERT INTO Patients (Username, Password, Email, Phone_Number) VALUES (%s, %s, %s, %s)"""
                cur_obj.execute(query, (new_username, new_password, new_email, new_phone))
                conn.commit()
                st.success('Account Created!')         
                 
elif selected_page == "Visit History":
    visit_history()
elif selected_page == "Invoices":
    invoices()
elif selected_page == "Schedule Appointment":
    schedule_appointment()
elif selected_page == "Hospitals":
    hospital_list()
elif selected_page == "Account Settings":
    account_settings()

def close_mysql_connection():
    conn.close()