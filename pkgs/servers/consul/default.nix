{ stdenv, lib, go, fetchgit, fetchhg, fetchbzr, fetchFromGitHub , ruby , nodejs
, bundlerEnv }:

let
  version = "0.4.1";
  # `sass` et al
  gems = bundlerEnv {
    name = "consul-deps";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in

with lib;
stdenv.mkDerivation {
  name = "consul-${version}";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ruby gems nodejs ];

  buildPhase = ''
    # Build consul binary
    export GOPATH=$src
    go build -v -o consul github.com/hashicorp/consul

    # Build ui static files
    ({
      cp -r src/github.com/hashicorp/consul/ui .
      cd ui
      chmod -R u+w .
      make dist
    })
  '';

  outputs = [ "out" "ui" ];

  installPhase = ''
    # Install consul binary
    mkdir -p $out/bin
    cp consul $out/bin

    # Install ui static files
    mkdir -p $ui
    mv ui/dist/* $ui
  '';

  meta = with lib; {
    homepage    = http://www.consul.io/;
    description = "A tool for service discovery, monitoring and configuration";
    maintainers = with maintainers; [ cstrahan wkennington ];
    license     = licenses.mpl20 ;
    platforms   = platforms.unix;
  };
}
