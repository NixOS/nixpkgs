{ stdenv, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "cadvisor-${version}";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "1li2qgfi4lfa2i1m7ykjxy1xm9hlq42fgdkb2wh2db9chyg5r4qp";
  };

  nativeBuildInputs = [ go ];

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
