{ stdenv, go16Packages, ruby, bundlerEnv, zip }:

let
  # `sass` et al
  gems = bundlerEnv {
    name = "consul-ui-deps";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in

stdenv.mkDerivation {
  name = "consul-ui-${go16Packages.consul.rev}";

  src = go16Packages.consul.src;

  buildInputs = [ ruby gems zip ];

  buildPhase = ''
    # Build ui static files
    cd ui
    make dist
  '';

  installPhase = ''
    # Install ui static files
    mkdir -p $out
    mv ../pkg/web_ui/* $out
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.consul.io/;
    description = "A tool for service discovery, monitoring and configuration";
    maintainers = with maintainers; [ cstrahan wkennington ];
    license     = licenses.mpl20 ;
    platforms   = platforms.unix;
  };
}
