      * Program: Temp_converter.cbl

      * This program converts a fahrenheit temp to centigrade.

       identification division.
       program-id. Temp_converter.

       environment division.    

       data division.
       working-storage section. 
       77 nInputFahr   pic s999999v99.
       77 neOutputCelc pic -zzzzz9.99.

       procedure division.
       000-main.
           display " ".
           display "Welcome user! This is a Temp Converter.".

           display " ".
           display "Please enter a tempurature in Fahrenheit...".
           accept nInputFahr.

           display " ".
           compute neOutputCelc = (nInputFahr - 32) * 0.5556.
           display "Your Centigrade value: ", neOutputCelc.

           display " ".
           display "Goodbye.".
           display " ".

           stop run.
