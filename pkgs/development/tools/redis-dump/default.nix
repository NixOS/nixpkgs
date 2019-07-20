{ lib, bundlerApp }:

bundlerApp {
  pname = "redis-dump";
  gemdir = ./.;
  exes = [ "redis-dump" ];

  meta = with lib; {
    description = "Backup and restore your Redis data to and from JSON";
    homepage    = http://delanotes.com/redis-dump/;
    license     = licenses.mit;
    maintainers = with maintainers; [ offline manveru ];
    platforms   = platforms.unix;
  };
}
