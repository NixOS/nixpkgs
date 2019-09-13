{ stdenv, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cadvisor";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    sha256 = "1hshmhsclja50ja2jqxx2f5lcvbs64n6aw6dw28wbnq3z9v0q8ad";
  };

  nativeBuildInputs = [ go ];

  buildPhase = ''
    export GOCACHE="$TMPDIR/go-cache"
    mkdir -p Godeps/_workspace/src/github.com/google/
    ln -s $(pwd) Godeps/_workspace/src/github.com/google/cadvisor
    GOPATH=$(pwd)/Godeps/_workspace go build -v -o cadvisor -ldflags="-s -w -X github.com/google/cadvisor/version.Version=${version}" github.com/google/cadvisor
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin cadvisor

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    homepage = https://github.com/google/cadvisor;
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
