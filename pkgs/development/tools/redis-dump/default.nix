{ lib, bundlerEnv, ruby, perl, autoconf }:

bundlerEnv {
  name = "redis-dump-0.3.5";

  inherit ruby;
  gemdir = ./.;

  buildInputs = [ perl autoconf ];

  meta = with lib; {
    broken = true; # needs ruby 2.0
    description = "Backup and restore your Redis data to and from JSON";
    homepage    = http://delanotes.com/redis-dump/;
    license     = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms   = platforms.unix;
  };
}
