{ stdenv, bundlerEnv, fetchFromGitHub, ruby, nodejs }:

let
  env = bundlerEnv {
    name = "frab";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in

stdenv.mkDerivation rec {
  name = "frab-2019-03-22";

  src = fetchFromGitHub {
    owner = "frab";
    repo = "frab";
    rev = "2b2785e03aaa5de7d7e3b97e2915fb11dd156b51";
    sha256 = "0n4g9nsqzrn7rla1ag0r28vih22a11crmqa9nd87ab4ymkadm37d";
  };

  buildInputs = [ nodejs env env.wrappedRuby ];

  RAILS_ENV = "production";
  SECRET_KEY_BASE = "dummy";

  buildPhase = ''
    cp config/database.yml.template config/database.yml
    cp .env.development .env.production
    rake assets:precompile
    rm .env.production
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/frab

    ln -sf /run/frab/database.yml $out/share/frab/config/database.yml
    rm -rf $out/share/frab/tmp $out/share/frab/public/system
    ln -sf /run/frab/system $out/share/frab/public/system
    ln -sf /tmp $out/share/frab/tmp
  '';

  passthru = {
    inherit env;
  };

  meta = with stdenv.lib; {
    description = "Web-based conference planning and management system";
    homepage = https://github.com/frab/frab;
    maintainers = with maintainers; [ manveru ];
    license = licenses.mit;
  };
}
