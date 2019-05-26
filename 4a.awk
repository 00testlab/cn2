BEGIN{
	sent_ps=0;
	time=0;
}
{
	if($1=="r" && $4=="1" && $5=="tcp")
	{
		time=$2;
		sent_ps+=$6;
		printf("\n%f\t%f",time,sent_ps/1000000);
	}
}
END{
}
