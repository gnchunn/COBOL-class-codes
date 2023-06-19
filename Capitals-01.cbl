       identification division.
       program-id. Capitals-01.
           
       environment division.
       input-output section.
       file-control.
           select masterFile assign to "Capitals.txt" organization is line sequential.

       data division.
       file section.
       fd masterFile.
       01 xInput.  
           05   xStateAbbrIn           pic x(2).
           05   xCapNameIn             pic x(14).
           05   nPopIn                 pic 9999999.
           05   nYearFounded           pic 9999.
           05   nPopRank               pic 99.
       
       01 xOutputRecord                pic x(80).
       
       working-storage section.
           77  xEofFlag                   pic x           value 'n'.
           77  nLoadSubscript             pic 9999        value 0.
           77  nProcessSubscript          pic 9999.
           77  nMinimum                   pic 9(10).
           77  nTotalCapitalsProcessed    pic 99          value 0. 
              
       01 xOutputHeading-1.
           05 filler                   pic x(7)    value "Capital".
           05 filler                   pic x(10)   value spaces.
           05 filler                   pic x(10)   value "Population".        
           05 filler                   pic x(1)    value spaces.
           05 filler                   pic x(7)    value "Founded".
           05 filler                   pic x(1)    value spaces.
           05 filler                   pic x(4)    value "Rank".
  
       01 xOutputDetail.
           05 xCapitalOut              pic x(18).
           05 filler                   pic xx      value spaces.           
           05 nePopulationOut          pic zzzzzz9.
           05 filler                   pic xx      value spaces.    
           05 neYearFoundedOut         pic 9999.
           05 filler                   pic xx      value spaces.
           05 nePopRankOut             pic z9.

       01 xCapitalTable.
           05  xCapitalElement occurs 50 times.
           10 xStateAbbr               pic x(2).
           10 xCapName                 pic x(14).
           10 nPop                     pic 9(7).
           10 nYear                    pic 9(4).
           10 nRank                    pic 9(2).

           
       01 xFooter-1.
           05 filler                    pic x(30)   value "Number of Capitals Processed: ".
           05 neTotalCapitalsProcessed  pic z9.

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
           close masterFile.

       
       110-next-record.
           read masterFile
               at end
                   move "y" to xEofFlag,
               not at end
                   add 1 to nLoadSubscript,
                   move xStateAbbrIn to xStateAbbr (nLoadSubscript),
                   move xCapNameIn to xCapName (nLoadSubscript),
                   move nPopIn to nPop (nLoadSubscript),
                   move nYearFounded to nYear (nLoadSubscript),
                   move nPopRank to nRank (nLoadSubscript),
           end-read.

       200-report.
           display " ".
           display "Minimum Population? " with no advancing.
           accept nMinimum.
           display xOutputHeading-1.
           
           if nMinimum not = 0
               perform 210-search varying nProcessSubscript from 1 by 1 until nProcessSubscript > nLoadSubscript,
           end-if.
       
       210-search.
           if nPop (nProcessSubscript) >= nMinimum
               move function concatenate (function trim(xCapName(nProcessSubscript)),
                   ", ", xStateAbbr(nProcessSubscript)) to xCapitalOut,
               move nPop (nProcessSubscript) to nePopulationOut,
               move nYear (nProcessSubscript) to neYearFoundedOut,
               move nRank (nProcessSubscript) to nePopRankOut,
               display xOutputDetail,
               add 1 to nTotalCapitalsProcessed,
           end-if.

           
       300-termination.

           
           display " ".
           
           move nTotalCapitalsProcessed to neTotalCapitalsProcessed.

           display xFooter-1.
           display " ".
