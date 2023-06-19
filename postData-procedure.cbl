*> File: postData-procedure.cbl
*>
*> This file contains the entire sub-program and user-defined functions for CGI programming.

identification division.
program-id. getPostData.

data division.
working-storage section.
77	xEofFlag							pic x				value "n".

procedure division.
		open input webinput.
		perform until xEofFlag = "y"
    	read webinput
      	at end
      		move "y" to xEofFlag
      	not at end
      		add 1 to postCount,
       		unstring postData delimited by "=" into postName(postCount), postValue(postCount),
    	end-read
    end-perform.
    close webinput.

end program getPostData.

identification division.
function-id. getPostValue.

data division.
linkage section.
01	name								pic x any length.
01	val								pic x(1024).

procedure division using name returning val.
		move spaces to val.
		set i to 1.
		search postElement when postName(i)=name
			move postValue(i) to val
		end-search.
		inspect val tallying inspectCount for all "<script".
		if inspectCount > 0
		  move "*****" to val
		end-if.

end function getPostValue.
