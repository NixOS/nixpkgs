{ stdenv, lib, go, fetchgit, fetchhg, fetchbzr, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "consul-template-${version}";
  version = "0.5.1";

  src = import ./deps.nix {
    inherit stdenv lib fetchgit fetchhg fetchbzr fetchFromGitHub;
  };

  buildInputs = [ go ];

  buildPhase = ''
    GOPATH=$src go build -v -o consul-template github.com/hashicorp/consul-template
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp consul-template $out/bin
  '';

  meta = with lib; {
    description = "Generic template rendering and notifications with Consul";
    homepage = https://github.com/hashicorp/consul-template;
    license = licenses.mpl20;
    maintainers = with maintainers; [ puffnfresh ];
    platforms = platforms.unix;
  };
}
