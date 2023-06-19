      * Program: exam01.cbl

      * This program converts an American dollar value to euros.

       identification division.
       program-id. exam01.

       environment division.    

       data division.
       working-storage section. 
       77 nInputDollar   pic s999999v99.
       77 neOutputEuro pic zzzzz9.99.

       procedure division.
       000-main.
           display " ".
           display "Welcome user, to the US Dollar to Euro Converter.".

           display " ".
           display "Please enter a US Dollar amount...".
           accept nInputDollar.

           display " ".
           compute neOutputEuro = nInputDollar * 0.84568.
           display "The Euro-value equivalent is... ", neOutputEuro.

           display " ".
           display "Goodbye.".
           display " ".

           stop run.
