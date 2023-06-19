identification division.
       program-id. Fruits-01.
 
       environment division.
       input-output section.
       file-control.
           select InFile assign to "FixedFruits.txt"
               organization is line sequential.
 
       data division.
       file section.
 
       fd InFile.
       01 xInput.
           05 xFruitNameIn     pic x(14).
           05 nFruitQtyIn      pic 9(3).
           05 nItemPriceIn     pic 9v99.

       working-storage section.

       77 xNewLine             pic x value x"0a".
       77 xEofFlag             pic x value 'n'.
       
       01 xHeader.
           
           05 filler               pic x(28)   value "<td><a2>Fruit Name</a2></td>".
           05 filler               pic x(26)   value "<td><a2>Quantity</a2></td>".
           05 filler               pic x(23)   value "<td><a2>Price</a2></td>".
           05 filler               pic x(31)   value "<td><a2>Fruit Picture</a2></td>".

       01 xOutput.
           05 filler               pic x(8)    value "<tr><td>".
           05 xFruitNameOut        pic x(14).
           05 filler               pic x(9)    value "</td><td>".
           05 neFruitQtyOut        pic zz9.
           05 filler               pic x(9)    value "</td><td>".
           05 neItemPriceOut       pic $9.z9.
           05 filler               pic x(9)    value "</td><td>".
           05 filler               pic x(10)   value '<img src="'.
           05 xFruitPicOut         pic x(25).
           05 filler               pic x(27)   value '" width="200" height="200">'.
           05 filler               pic x(10)   value "</td></tr>".
 
       procedure division.
       000-main.
           perform 100-initialization.
           perform 200-generate-table.
           perform 300-termination.
           stop run.
 
       100-initialization.
           open input InFile.
 
           display "Content-type: text/html", xNewLine.
 
           display "<!doctype html>".
           display "<html>".
           display "<head>".
           display "<title>Fruit-01.cbl</title>".
           display "<link rel=stylesheet type='text/css' href='cobol.css'>".
           display "</head>".
 
           display "<body>".

       200-generate-table.
           display "<table>";
           
           display xHeader.

           perform 210-loop until xEofFlag = "y".
           display "</table>".
 
       210-loop.
           read InFile
           at end
               move 'y' to xEofFlag
           not at end
               perform 220-process
           end-read.
 
       220-process.
           move xFruitNameIn to xFruitNameOut.
           move nFruitQtyIn to neFruitQtyOut.
           move nItemPriceIn to neItemPriceOut.
           move function concatenate (function trim(xFruitNameIn), ".png") to xFruitPicOut.

           display xOutput.
 
       300-termination.
           close InFile.
           display "</body>".
           display "</html>".
