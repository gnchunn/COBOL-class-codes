       identification division.
       program-id. exam02soccer.
           
       environment division.
       input-output section.
       file-control.
           select masterFile assign to "soccer.txt" organization is line sequential.

       data division.
       file section.
       fd masterFile.
       01 xInput.  
           05   xSchoolIn                 pic x(15).
           05   xMascotIn                 pic x(15).
           05   nWinsIn                   pic 99.
           05   nLossesIn                 pic 99.
       
       01 xOutputRecord                   pic x(80).
       
       working-storage section.
           77  xEofFlag                   pic x           value 'n'.
           77  nLoadSubscript             pic 9999        value 0.
           77  nProcessSubscript          pic 9999.
           77  nMinimum                   pic 9v999.
           77  nTotalTeamsProcessed       pic 99          value 0.
           77  nWinPercentage             pic 9v999       value 0.
  
       01 xOutputDetail.
           05 xSchoolOut               pic x(15).
           05 filler                   pic xx      value spaces.           
           05 xMascotOut               pic x(15).
           05 filler                   pic xx      value spaces.    
           05 neWinsOut                pic z9.
           05 filler                   pic xx      value spaces.
           05 neLossesOut              pic z9.
           05 filler                   pic xx      value spaces.
           05 neWinPercentageOut       pic 9.999.

       01 xTeamsTable.
           05  xTeamElement occurs 50 times.
           10 xSchool                  pic x(15).
           10 xMascot                  pic x(15).
           10 nWins                    pic 9(2).
           10 nLosses                  pic 9(2).

           
       01 xFooter-1.
           05 filler                   pic x(26)   value "MSU Soccer has at least a ".
           05 neMinimum                pic 9.999.
           05 filler                   pic x(29)   value " winning percentage againast ".
           05 neTotalTeamsProcessed    pic z9.
           05 filler                   pic x(9)    value " schools.".


       procedure division.
       000-main.
           
           perform 100-initialization.
           perform 200-report.
           perform 300-termination.
           stop run.
       
       100-initialization.
           
           display " ".
           
           open input masterFile.
           perform 110-next-record until xEofFlag = "y".

       
       110-next-record.
           read masterFile
               at end
                   move "y" to xEofFlag,
               not at end
                   add 1 to nLoadSubscript,
                   move xSchoolIn to xSchool (nLoadSubscript),
                   move xMascotIn to xMascot (nLoadSubscript),
                   move nWinsIn to nWins (nLoadSubscript),
                   move nLossesIn to nLosses (nLoadSubscript),
           end-read.

       200-report.
           display " ".
           display "Please enter a minimum win percentage ".
           display "(ex. 0.50 for 50 percent): " with no advancing.
           accept nMinimum.
           
           if nMinimum not = 0
               perform 210-search varying nProcessSubscript from 1 by 1 until nProcessSubscript > nLoadSubscript,
           end-if.
       
       210-search.
           
           compute nWinPercentage = nWins (nProcessSubscript) / (nWins (nProcessSubscript) + nLosses (nProcessSubscript)).

           if nWinPercentage >= nMinimum
               move xSchool (nProcessSubscript) to xSchoolOut,
               move xMascot (nProcessSubscript) to xMascotOut,
               move nWins (nProcessSubscript) to neWinsout,
               move nLosses (nProcessSubscript) to neLossesOut,
               move nWinPercentage to neWinPercentageOut,
               display xOutputDetail,
               add 1 to nTotalTeamsProcessed,
           end-if.

           
       300-termination.
           close masterfile.
           
           display " ".
           
           move nTotalTeamsProcessed to neTotalTeamsProcessed.
           move nMinimum to neMinimum.

           display xFooter-1.
           display " ".
