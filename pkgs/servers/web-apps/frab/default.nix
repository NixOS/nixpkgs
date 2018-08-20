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
  name = "frab-2016-12-28";

  src = fetchFromGitHub {
    owner = "frab";
    repo = "frab";
    rev = "e4bbcfd1a9db7f89f53a8702c236d9628bafb72c";
    sha256 = "04pzmif8jxjww3fdf2zbg3k7cm49vxc9hhf4xhmvdmvywgin6fqp";
  };

  buildInputs = [ env nodejs ];

  buildPhase = ''
    cp config/database.yml.template config/database.yml
    cp .env.development .env.production
    bundler exec rake assets:precompile RAILS_ENV=production
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
    inherit env ruby;
  };

  meta = with stdenv.lib; {
    description = "Web-based conference planning and management system";
    homepage = https://github.com/frab/frab;
    license = licenses.mit;
  };
}
