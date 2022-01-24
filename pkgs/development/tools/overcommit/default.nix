{ lib, bundlerApp }:

bundlerApp {
  pname = "overcommit";
  gemdir = ./.;
  exes = [ "overcommit" ];

  meta = with lib; {
    description = "Tool to manage and configure Git hooks";
    homepage    = "https://github.com/sds/overcommit";
    license     = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms   = platforms.unix;
  };
}
