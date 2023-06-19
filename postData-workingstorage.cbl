*> File: postData-workingstorage.cbl

01	postArray global.
	05	postElement occurs 25 times indexed by i.
		10	postName		pic x(25).
		10	postValue		pic x(50).
77	postCount global			pic 99		value 0.
77	name global				pic x(50).
77	val global				pic x(1024).
77	inspectCount global			pic 999.
