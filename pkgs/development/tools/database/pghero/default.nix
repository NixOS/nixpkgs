{ stdenv, fetchFromGitHub, bundlerEnv, writeShellScriptBin }:
let
  env = bundlerEnv {
    name = "pghero";
    gemdir = ./.;
  };

 pghero = stdenv.mkDerivation rec {
  pname = "pghero";
  version = (import ./gemset.nix).pghero.version;
  src = fetchFromGitHub {
    owner = "pghero";
    repo = "pghero";
    rev = "v2.3.0";
    sha256 = "0fh6ssxp3gh50sqd0sl264p62jg1swdgkm7wi5dfsqc8rh8zcpbz";
  };

  buildInputs = [ env ];

  RAILS_ENV = "production";
  DATABASE_URL = "postgresql://user:pass@127.0.0.1/dbname";
  SECRET_TOKEN = "dummytoken";

  buildPhase = ''
    mkdir -p $out/lib $out/bin
    cp -r $src $out/lib/pghero/
    chmod u+rw -R $out
    cd $out/lib/pghero
    rake assets:precompile
    rm -rf tmp
  '';

  installPhase = ''
    echo "#!${stdenv.shell}" > $out/bin/pghero
    echo "cd $out/lib/pghero" >> $out/bin/pghero
    echo "${env}/bin/puma -C config/puma.rb" >> $out/bin/pghero
    chmod +x $out/bin/pghero
  '';

  meta = with stdenv.lib; {
    description = "Performance dashboard for PostgreSQL";
    homepage = "https://pghero.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ manveru ];
  };
};
in pghero
