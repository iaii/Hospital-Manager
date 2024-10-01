# Hospital-Manager


# CPSC408 Final Project
## Hostpital Management

### Apoorva Chilukuri, Caroline Robinson, Sanjeev Narasimhan, Anna Harner

# Resources: 
- StreamLit API https://docs.streamlit.io/develop/api-reference
- Debugging using ChatGPT 
Libraries Installed:
- numpy
- pandas
- datetime
- random
- mysql.connector
- streamlit
- sqlalchemy
- psycopg2

# Files
- hospital_manager.py

# Setup and Usage:
- Ensure HospitalManager schema is active in MySQL
- Modify any MySQL authentification in hospital_manager.py script (user, pass, etc)
- run script in command line:
    - streamlit run hospital_view.py

    Or if that doesn't work, we had to run it in a different way (example):
    - streamlit run "/Users/carolinerobinson/Documents/CPSC_Courses/CPSC408/Hospital Manager/hospital_view.py" --browser.serverAddress="localhost" --browser.gatherUsageStats=false
- streamlit should then activate and frontend will be functional in web browser


### Incase you have trouble with setting up our schema:
-- Hospital Records App Schema


DROP SCHEMA IF EXISTS HospitalRecordsApp;
CREATE SCHEMA HospitalRecordsApp;
USE HospitalRecordsApp;




--
-- Table structure for table `Hospitals`
--


CREATE TABLE Hospitals(
  Hospital_ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Hospital_Name VARCHAR(20),
  Region VARCHAR(20),
  State VARCHAR(20),
  Address VARCHAR(30)
);


--
-- Table structure for table `Doctors`
--


CREATE TABLE Doctors(
  Doctor_ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  First_Name VARCHAR(20),
  Last_Name VARCHAR(20),
  Age INTEGER,
  Specialty VARCHAR(20),
  Sub_Specialty VARCHAR(20),
  Email VARCHAR(30),
  Phone_Number VARCHAR(20),
  Primary_Hospital_ID INTEGER,
  FOREIGN KEY (Primary_Hospital_ID) REFERENCES Hospitals(Hospital_ID)
);


--
-- Table structure for table `Patients`
--


CREATE TABLE Patients(
  Patient_ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Insurance_Number VARCHAR(20),
  First_Name VARCHAR(20),
  Last_Name VARCHAR(20),
  Username VARCHAR(20),
  Password VARCHAR(20),
  Age INTEGER,
  Email VARCHAR(20),
  Phone_Number VARCHAR(20),
  Blood_Type VARCHAR(5),
  Primary_Doctor_ID INTEGER,
  FOREIGN KEY (Primary_Doctor_ID) REFERENCES Doctors(Doctor_ID)
);


--
-- Table structure for table `Invoices`
--


CREATE TABLE Invoices(
  Invoice_ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Date DATETIME,
  Patient_ID INTEGER,
  Hospital_ID INTEGER,
  FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
  FOREIGN KEY (Hospital_ID) REFERENCES Hospitals(Hospital_ID),
  CoPay_Amt DOUBLE,
  Purpose VARCHAR(350)
);


--
-- Table structure for table `Visits`
--


CREATE TABLE Visits(
  Visit_ID INTEGER NOT NULL PRIMARY KEY,
  Date DATETIME,
  Patient_ID INTEGER,
  Doctor_ID INTEGER,
  FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
  FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
  Purpose VARCHAR(350),
  Visit_Completed BOOLEAN DEFAULT 0,
  Is_Deleted BOOLEAN DEFAULT 0
);

INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'aoic', 'b', 'a', 'c', 34, 'a', 23, 'A', 1);


INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'acs', 'b', 'a', 'c', 34, 'a', 23, 'A', 1);

INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'aac', 'b', 'a', 'c', 34, 'a', 23, 'A', 1);

INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'ac', 'b', 'a', 'c', 34, 'a', 23, 'A', 2);

INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'aec', 'b', 'a', 'c', 34, 'a', 23, 'A', 2);

INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'arc', 'b', 'a', 'c', 34, 'a', 23, 'A', 3);

INSERT INTO HospitalRecordsApp.patients(
  Insurance_Number,
  First_Name,
  Last_Name,
  Username,
  Password,
  Age,
  Email,
  Phone_Number,
  Blood_Type,
  Primary_Doctor_ID) values (1, 'ack', 'b', 'a', 'c', 34, 'a', 23, 'A', 10);


USE HospitalRecordsApp;
CREATE VIEW view_patient_invoices AS
SELECT Invoices.Invoice_ID AS InvoiceID,
    Invoices.Patient_ID,
    Invoices.Date,
    Invoices.CoPay_Amt AS CoPay_Amount,
    Invoices.Purpose AS Visit_Purpose,
    Hospitals.Hospital_Name,
    Hospitals.Address
FROM Invoices
INNER JOIN Hospitals
    ON Invoices.Hospital_ID = Hospitals.Hospital_ID;
USE HospitalRecordsApp;
CREATE INDEX idx_invoice_patient_id ON invoices(patient_id);

ALTER TABLE Patients
ADD COLUMN Is_Deleted INT DEFAULT 0;

