{ grafanaPlugin, lib }:

 grafanaPlugin rec {
   pname = "victorialogs-datasource";
   version = "0.14.3";
   zipHash = "sha256-sVHLmN/smfVV02h3Vy+VoHXYR+pqQ/yyGxhQrbtdRQA=";
   meta = with lib; {
     description = "Connect Grafana to VictoriaLogs";
     license = licenses.asl20;
     maintainers = with maintainers; [ lis ];
     platforms = platforms.unix;
   };
 }
