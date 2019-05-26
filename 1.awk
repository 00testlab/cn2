BEGIN{
	tcpr=0;
	tcpd=0;
	udpr=0;
	udpd=0;
}
{
	if($1=="r" && $5=="tcp")
	tcpr++;
	if($1=="d" && $5=="tcp")
	tcpd++;
	if($1=="r" && $5=="cbr")
	udpr++;
	if($1=="d" && $5=="cbr")
	udpd++;
}
END{
printf("TCP Recieved= %d\nTCP Droped= %d\nUDP Recieved= %d\nUDP Droped= %d\n",tcpr,tcpd,udpr,udpd);
}
