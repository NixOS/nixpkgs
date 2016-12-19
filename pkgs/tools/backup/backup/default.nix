{ stdenv, lib, bundlerEnv, ruby_2_1, curl }:

bundlerEnv {
  name = "backup_v4";

  ruby = ruby_2_1;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  buildInputs = [ curl ];

  meta = with lib; {
    description = "Easy full stack backup operations on UNIX-like systems";
    homepage    = http://backup.github.io/backup/v4/;
    license     = licenses.mit;
    maintainers = [ maintainers.palo ];
    platforms   = platforms.unix;
  };
}
