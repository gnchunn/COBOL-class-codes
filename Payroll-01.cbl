       identification division.
       program-id. Payroll-01.
           
       environment division.
       input-output section.

       file-control.
           select infile assign to "Payroll.transaction.txt" organization is line sequential.
           select masterfile assign to "Payroll.master.txt" organization is line sequential.
           select outfile assign to "Payroll-01-output.txt" organization is line sequential.
       
       data division.
       file section.
       fd infile.
       01 xInput.
           05   nEmpNumIn                 pic 9999.  
           05   nHoursWorked              pic 999.

       fd masterfile.
       01 xMaster.
           05 nDept                       pic 9.
           05 nEmpNumMstr                 pic 9999.
           05 xLastName                   pic x(20).
           05 xFirstName                  pic x(20).
           05 nPayRate                    pic 999v99.

       fd outfile.
       01 xOutput                         pic x(80).

       working-storage section.
       77 xEofFlagTx                      pic x       value 'n'.
       77 xEofFlagMaster                  pic x       value 'n'.
       77 nEmployeeCount                  pic 999     value 0.
       77 nTotalHours                     pic 999     value 0.
       77 nGrossPay                       pic 999v99  value 0.
       77 nTotalGrossPay                  pic 9999v99 value 0.
       77 nEmpNumFound                    pic 9       value 0.

       01 xOutputHeading-1.
           05 filler                      pic x(5)    value "DEPT".
           05 filler                      pic x(8)    value "EMP NUM".
           05 filler                      pic x(9)    value "EMP NAME".
           05 filler                      pic x(25)   value spaces.
           05 filler                      pic x(8)    value "EMP HRS".
           05 filler                      pic x(7)    value "EMP PAY".

       01 xOutputHeading-2.
           05 filler                      pic x(5)    value "----".
           05 filler                      pic x(8)    value "-------".
           05 filler                      pic x(9)    value "--------".
           05 filler                      pic x(25)   value spaces.
           05 filler                      pic x(8)    value "-------".
           05 filler                      pic x(7)    value "-------".

       01 xOutputDetail.
           05 neDeptOut                   pic z9.
           05 filler                      pic xx      value spaces.
           05 neEmpNumOut                 pic zzz9.
           05 filler                      pic xx      value spaces.
           05 xEmployeeName               pic x(34).
           05 filler                      pic xx      value spaces.    
           05 neHoursWorked               pic zzz9.
           05 filler                      pic xx      value spaces.
           05 neGrossPay                  pic zzz9.99.

       01 xFooter-1.
           05 filler                      pic x(5)    value "----".
           05 filler                      pic x(8)    value "-------".
           05 filler                      pic x(9)    value "--------".
           05 filler                      pic x(25)   value spaces.
           05 filler                      pic x(8)    value "-------".
           05 filler                      pic x(7)    value "-------".

       01 xFooter-2.
           05 neEmployeeCount             pic zz9.
           05 filler                      pic x(14)   value ' employees'.
           05 neTotalHours                pic zzzz9.
           05 filler                      pic x(20)   value ' hrs worked'.
           05 neTotalGrossPay             pic $zz,zz9.99.
           05 filler                      pic x(10) value ' gross pay'.

       procedure division.
       000-main.
           
           perform 100-initialization.
           perform 200-loop until xEofFlagTx = 'y'.
           perform 300-termination.
           stop run.
       
       100-initialization.
           open input infile.
           open output outfile.
           display xOutputHeading-1.
           display xOutputHeading-2.
           write xOutput from xOutputHeading-1 before advancing 1 line.
           write xOutput from xOutputHeading-2 before advancing 1 line.
       
       200-loop.
           read infile
               at end
                   move 'y' to xEofFlagTx,
               not at end
                   perform 210-process,
           end-read.
       
       210-process.
           move "n" to xEofFlagMaster.
           open input masterfile.
           perform 220-read-master until xEofFlagMaster = "y".
           close masterfile.

           multiply nHoursWorked by nPayRate giving nGrossPay rounded.
           add nGrossPay to nTotalGrossPay.

           move nTotalGrossPay to neTotalGrossPay.
           move nGrossPay to neGrossPay.

           add nHoursWorked to nTotalHours.
           
           add 1 to nEmployeeCount

           display xOutputDetail.

       220-read-master.
           read masterfile
               at end
                   move "y" to xEofFlagMaster,
               not at end
                   if nEmpNumIn = nEmpNumMstr
                       perform 230-generate-detail,
                       move "y" to xEofFlagMaster,
                       move 1 to nEmpNumFound,
                   end-if,
               end-read.
              
       230-generate-detail.
           move nDept to neDeptOut.
           move nEmpNumIn to neEmpNumOut.
           move function concatenate (function trim(xLastName), ", ", xFirstName) to xEmployeeName.
           move nHoursWorked to neHoursWorked.

           write xOutput from xOutputDetail before advancing 1 line.
           
       300-termination.
           close infile.

           display xFooter-1.
           write xOutput from xFooter-1 before advancing 1 line.

           display " ".

           move nEmployeeCount to neEmployeeCount.
           move nTotalHours to neTotalHours.
           move nTotalGrossPay to neTotalGrossPay.

           display xFooter-2.
           write xOutput from xFooter-2 before advancing 1 line.

           display " ".

           close outfile.
