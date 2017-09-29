{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cadvisor-${version}";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "0rv245acz2r12c6ga2ln01961sh36w15ay0nfpfcg8inz679dnvg";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p Godeps/_workspace/src/github.com/google/
    ln -s $(pwd) Godeps/_workspace/src/github.com/google/cadvisor
    GOPATH=$(pwd)/Godeps/_workspace go build -v -o cadvisor github.com/google/cadvisor
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv cadvisor $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = https://github.com/google/cadvisor;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
