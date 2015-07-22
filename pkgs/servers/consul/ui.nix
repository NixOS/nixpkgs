{ stdenv, goPackages, ruby, bundlerEnv }:

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
  name = "consul-ui-${goPackages.consul.rev}";

  src = goPackages.consul.src;

  buildInputs = [ ruby gems ];

  buildPhase = ''
    # Build ui static files
    cd ui
    make dist
  '';

  installPhase = ''
    # Install ui static files
    mkdir -p $out
    mv dist/* $out
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.consul.io/;
    description = "A tool for service discovery, monitoring and configuration";
    maintainers = with maintainers; [ cstrahan wkennington ];
    license     = licenses.mpl20 ;
    platforms   = platforms.unix;
  };
}
