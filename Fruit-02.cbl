identification division.
       program-id. Fruit-02.
 
       environment division.
           
           copy "postData-environmentdivision.cbl".

       input-output section.
       file-control.
           select InFile assign to "FixedFruits.txt"
               organization is line sequential.
           copy "postData-filecontrol.cbl".
 
       data division.
       file section.

       fd  webinput.
       01  xPostData            pic x(1024).
           copy "postData-filesection.cbl".
 
       fd  InFile.
       01  xInput.
           05 xFruitNameIn     pic x(14).
           05 nFruitQtyIn      pic 9(3).
           05 nItemPrice       pic 9v99.

       working-storage section.
       77  xNewLine             pic x value x"0a".
       77  xEofFlag             pic x value 'n'.
       77  xProcessName         pic x(14).

       01 xOutput-1.
           05 filler               pic x(8)    value "<tr><td>".
           05 xFruitNameOut        pic x(14).
           05 filler               pic x(9)    value "</td><td>".
           05 neFruitQtyOut        pic zz9.
           05 filler               pic x(9)    value "</td><td>".
           05 neItemPriceOut       pic $9.z9.
           05 filler               pic x(10)    value "</td></tr>".
       
       01 xOutput-02.
           05 filler               pic x(31)   value "<tr><td colspan=3 align=center>".
           05 filler               pic x(10)   value "<img src='".
           05 xFruitPicOut         pic x(14).
           05 filler               pic x(2)    value "'>".
           05 filler               pic x(10)   value "</td></tr>".

           copy "postData-workingstorage.cbl".
 
       procedure division.
       000-main.
           perform 100-initialization.
           perform 200-processing.
           perform 300-termination.
           stop run.
 
       100-initialization.
           display "Content-type: text/html", xNewLine.
 
           display "<!doctype html>".
           display "<html>".
           display "<head>".
           display "<title>Fruit-02.cbl</title>".
           display "<link rel=stylesheet type='text/css' href='cobol.css'>".
           display "</head>".
           display "<body>".

           call "getPostData".
           move function getPostValue("fruitname") to xProcessName.
           
       200-processing.
           display "<table>".
           open input InFile.
           perform 210-loop until xEofFlag = "y".
           close InFile.
           display "</table>".
 
       210-loop.
           read InFile
           at end
               move "y" to xEofFlag
           not at end
           if xFruitNameIn = xProcessName
               perform 220-display,
           end-if
           end-read.
 
       220-display.
           move xFruitNameIn to xFruitNameOut.
           move nFruitQtyIn to neFruitQtyOut.
           move nItemPrice to neItemPriceOut.
           move function concatenate (function trim(xFruitNameIn), ".png") to xFruitPicOut.

           display xOutput-1.
           display xOutput-02.
           

 
       300-termination.
           display "</body>".
           display "</html>".

           copy "postData-procedure.cbl".
