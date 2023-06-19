       identification division.
       program-id. States-06.
           
       environment division.
       input-output section.
       file-control.
           select inFile assign to "States.txt" organization is line sequential.

       data division.
       file section.

       fd inFile.
       01 xInput.  
           05   nStateNumIn                pic 99.
           05   xStateAbbrIn               pic x(2).
           05   xRegionIn                  pic x.
           05   xStateNameIn               pic x(20).
           05   nPopIn                     pic 9(8).
           05   nAreaIn                    pic 9(6).
    
       01 xOutputRecord                    pic x(80).
       
       working-storage section.
           77  xEofFlag                    pic x               value 'n'.
           77  nLoadSubscript              pic 9999            value 0.
           77  nProcessSubscript           pic 9999.
           77  nRegionSubStates            pic 99              value 0.
           77  nRegionSubPop               pic 999999999v99    value 0. 
           77  nRegionSubArea              pic 9999999v99      value 0.        
           77  nRegionSubDensity           pic 999999v99       value 0.
           77  nSubStates                  pic 99              value 0. 
           77  nSubPop                     pic 999999999v99    value 0. 
           77  nSubArea                    pic 9999999v99      value 0. 
           77  nSubDensity                 pic 999999v99       value 0.
           77  xOldRegion                  pic x               value 'e'. 
       
       01 xStateTable.

           05 xStateElement occurs 51 times.
           10 xRegionCode                  pic x.
           10 xStateName                   pic x(20).
           10 nPop                         pic 9(8).
           10 nArea                        pic 9(6).
           10 nDensity                     pic 9(4)v99.

       01 xOutputDetail.
           05 xRegionCodeOut               pic x.
           05 filler                       pic xx      value spaces.           
           05 xStateNameOut                pic x(20).
           05 filler                       pic xx      value spaces.    
           05 nePopOut                     pic zzz,zzz,zz9.
           05 filler                       pic xx      value spaces.
           05 neAreaOut                    pic z,zzz,zz9.
           05 filler                       pic xx      value spaces.
           05 neDensity                    pic zzzz.z9.

       01 xFooter-1.
           05 filler                       pic xx.
           05 neSubStates                  pic z9.
           05 filler                       pic x(7)   value " states". 
           05 filler                       pic x(14).
           05 neSubPop                     pic 9zz,zzz,zz9.
           05 filler                       pic xx.
           05 neSubArea                    pic z,zzz,zz9.
           05 filler                       pic x(3).
           05 neSubDensity                 pic zzz.z9.  
       
       01 xControl.
           05 filler                       pic xx.
           05 neRegionSubStates            pic z9.
           05 filler                       pic x(7)   value " states". 
           05 filler                       pic x(14).
           05 neRegionSubPop               pic 9zz,zzz,zz9.
           05 filler                       pic xx.
           05 neRegionSubArea              pic z,zzz,zz9.
           05 filler                       pic x(3).
           05 neRegionSubDensity           pic zzz.z9.
             

       procedure division.
       000-main.
           
           perform 100-initialization.
           perform 200-report.
           perform 300-termination.
           stop run.
       
       100-initialization.
           
           display " ".
           
           open input inFile.
           perform 110-load-table until xEofFlag = "y".
           close inFile.

       
       110-load-table.
           read inFile
               at end
                   move "y" to xEofFlag,
               not at end
                   add 1 to nLoadSubscript,
                   move xRegionIn to xRegionCode (nLoadSubscript),
                   move xStateNameIn to xStateName (nLoadSubscript),
                   move nPopIn to nPop (nLoadSubscript),
                   move nAreaIn to nArea (nLoadSubscript),
                   divide nPopIn by nAreaIn giving nDensity (nLoadSubscript),
           end-read.

       200-report.
           sort xStateElement on ascending key xRegionCode.

           perform 210-output varying nProcessSubscript from 1 by 1 
               until nProcessSubscript > nLoadSubscript.
           
       210-output.
           
           if xRegionCode (nProcessSubscript) not = xOldRegion
               perform 220-control
           end-if.
           
           add 1 to nRegionSubStates,
           
           
           move xRegionCode (nProcessSubscript) to xRegionCodeOut, xOldRegion.
           move xStateName (nProcessSubscript) to xStateNameOut,
           move nPop (nProcessSubscript) to nePopOut,
           move nArea (nProcessSubscript) to neAreaOut,
           add nPop (nProcessSubscript) to nRegionSubPop,
           add nArea (nProcessSubscript) to nRegionSubArea,              
           
           add 1 to nSubStates,
           add nPop (nProcessSubscript) to nSubPop,
           add nArea (nProcessSubscript) to nSubArea,              
           move nDensity (nProcessSubscript) to neDensity,
           add nDensity (nProcessSubscript) to nSubDensity,
           display xOutputDetail.

       220-control.
           display ' '.

           divide nRegionSubPop by nRegionSubArea giving nRegionSubDensity.

           move nRegionSubStates to neRegionSubStates,    
           move nRegionSubPop to neRegionSubPop,   
           move nRegionSubArea to neRegionSubArea,              
           move nRegionSubDensity to neRegionSubDensity.
           
           display " ".
           display xControl.
           display " ".
           move 0 to nSubStates, nSubPop,
           nRegionSubDensity, nSubArea, nSubDensity, 
           nSubStates.  

       300-termination.
           display " ".
           
           divide nSubPop by nSubArea giving nRegionSubDensity.

           divide nSubPop by nSubArea giving nSubDensity.
           
           move nSubStates to neSubStates.
           move nSubPop to neSubPop.
           move nSubArea to neSubArea.
           move nSubDensity to neSubDensity.
           display xFooter-1.
           display " ".
