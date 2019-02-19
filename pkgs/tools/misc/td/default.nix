{ lib, bundlerApp }:

bundlerApp {
  pname = "td";
  gemdir = ./.;
  exes = [ "td" ];

  meta = with lib; {
    description = "CLI to manage data on Treasure Data, the Hadoop-based cloud data warehousing.";
    homepage    = https://github.com/treasure-data/td;
    license     = licenses.asl20;
    maintainers =  with maintainers; [ groodt ];
    platforms   = platforms.unix;
  };
}
