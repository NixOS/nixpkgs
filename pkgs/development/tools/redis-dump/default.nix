{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "redis-dump";
  gemdir = ./.;
  exes = [ "redis-dump" "redis-load" ];

  passthru.updateScript = bundlerUpdateScript "redis-dump";

  meta = with lib; {
    description = "Backup and restore your Redis data to and from JSON";
    homepage    = "http://delanotes.com/redis-dump/";
    license     = licenses.mit;
    maintainers = with maintainers; [ offline manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
