       identification division.
       program-id. States-01.
           
       environment division.
       input-output section.
       file-control.
           select infile assign to "States.txt" organization is line sequential.
           select outfile assign to "States-01-output.txt" organization is line sequential.
       
       data division.
       file section.
       fd infile.
       01 xInput.
           05   nStateNumber           pic 99.  
           05   xStateAbbreviation     pic x(2).
           05   xRegionCode            pic x(1).
           05   xStateName             pic x(20).
           05   nPopulation            pic 99999999.
           05   nArea                  pic 999999.

       fd outfile.
       01 xOutput                      pic x(80).

       working-storage section.
           77  xEofFlag                   pic x           value 'n'.
           77  nStateCounter              pic 99          value 0.
           77  nTotalPop                  pic 999999999. 
           77  nTotalArea                 pic 9999999. 
           77  nDensity                   pic 9999999.99.
           77  nTotalDensity              pic 9999999.99.
           
       01 xOutputHeading-1.
           05 filler                   pic x(10)   value "State Name".
           05 filler                   pic x(12)   value spaces.
           05 filler                   pic x(10)   value "Population".        
           05 filler                   pic x(5)    value spaces.
           05 filler                   pic x(4)    value "Area".
           05 filler                   pic x(7)    value spaces.
           05 filler                   pic x(7)    value "Density".

       01 xOutputHeading-2.
           05 filler                   pic x(20)   value "____________________".
           05 filler                   pic xx      value spaces.
           05 filler                   pic x(10)   value "__________".
           05 filler                   pic xx      value spaces.
           05 filler                   pic x(7)    value "_______".
           05 filler                   pic x(3)    value spaces.
           05 filler                   pic x(11)   value "___________".

       01 xOutputDetail.
           05 xStateNameOut            pic x(20).
           05 filler                   pic xx      value spaces.
           05 nePopulationOut          pic zz,zzz,zz9.
           05 filler                   pic xx      value spaces.    
           05 neAreaOut                pic zzz,zz9.
           05 filler                   pic xx      value spaces.
           05 neDensityOut             pic z,zzz,zz9.99.
           
       01 xFooter-1.
           05 filler                   pic x(20)   value "____________________".
           05 filler                   pic xx      value spaces.
           05 filler                   pic x(10)   value "__________".
           05 filler                   pic xx      value spaces.
           05 filler                   pic x(7)    value "_______".
           05 filler                   pic x(3)    value spaces.
           05 filler                   pic x(11)   value "___________".

       01 xFooter-2.
           05 neStateCounter           pic 99      value 0.
           05 filler                   pic xx      value spaces.
           05 filler                   pic x(6)    value "states".
           05 filler                   pic xx(10)  value spaces.
           05 neTotalPop               pic zzz,zzz,zz9.
           05 filler                   pic xx      value spaces.
           05 neTotalArea              pic z,zzz,zz9.
           05 neTotalDensity           pic z,zzz,zz9.99.
           
       procedure division.
       000-main.
           
           perform 100-initialization.
           perform 200-loop until xEofFlag = 'y'.
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
                   move 'y' to xEofFlag,
               not at end
                   perform 210-process,
           end-read.
       
       210-process.
           move xStateName to xStateNameOut.
           move nPopulation to nePopulationOut.
           move nArea to neAreaOut.

           divide nPopulation by nArea giving nDensity.
           move nDensity to neDensityOut

           display xOutputDetail.
           write xOutput from xOutputDetail before advancing 1 line.

           add 1 to nStateCounter.
           add nPopulation to nTotalPop.
           add nArea to nTotalArea.
           
       300-termination.
           close infile.
           
           display xFooter-1.
           write xOutput from xFooter-1 before advancing 1 line.

           display " ".

           divide nTotalPop by nTotalArea giving nTotalDensity.

           move nStateCounter to neStateCounter.
           move nTotalPop to neTotalPop.
           move nTotalArea to neTotalArea.
           move nTotalDensity to neTotalDensity.
           
           display xFooter-2.
           write xOutput from xFooter-2 before advancing 1 line.

           display " ".

           close outfile.
