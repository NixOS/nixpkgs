{ stdenv, lib, bundlerEnv, ruby, curl }:

bundlerEnv {
  name = "backup_v4";

  inherit ruby;
  gemdir = ./.;

  buildInputs = [ curl ];

  meta = with lib; {
    broken = true; # need ruby 2.1
    description = "Easy full stack backup operations on UNIX-like systems";
    homepage    = http://backup.github.io/backup/v4/;
    license     = licenses.mit;
    maintainers = [ maintainers.mrVanDalo ];
    platforms   = platforms.unix;
  };
}
