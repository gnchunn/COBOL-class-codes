      * Program: HelloWorld.cbl
      * 
      * Introduction assignment for COBOL class
      * 
      * to compile:   cobc -x HelloWorld.cbl
      * to run the executable: ./HelloWorld

       identification division.
       program-id. HelloWorld.

       environment division.
       input-output section.
       file-control.

       data division.

       procedure division.
       000-main.
           display" ".
           display "Hello world".
           display" ".
           stop run.
