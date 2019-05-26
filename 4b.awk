BEGIN{
	total_b_s=0;
	total_b_r=0;
}
{
	if($3==0 && $1=="+" && $5=="tcp")
	total_b_s+=$6;
	if($4==1 && $1=="r" && $5 == "tcp")
	total_b_r+=$6;
}
END{
	printf("Total Data Sent: %fMB \n Total Data Recieved:%fMB\n ",total_b_s/1000000,total_b_r/1000000);
}
