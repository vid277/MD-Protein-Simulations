# prior to sourcing, move all files to directory "dir"
for FILE in dir/*;	
	do echo $FILE;
	#shave the first two lines off the top of the file
	echo "$(tail -n +2 $FILE)" > $FILE;
	# add a column to the end with the file name on every line 
	awk -i inplace '{print $0 OFS FILENAME}' $FILE;
	# replace the top line with a header for all three
	headvar="donor	acceptor	occupancy	filename"
	sed -i "1s/.*/$headvar/" $FILE
done
