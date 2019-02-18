{ stdenv, buildGoPackage, fetchFromGitHub, bash, go-bindata}:

buildGoPackage rec {
  name = "traefik-${version}";
  version = "1.7.8";

  goPackagePath = "github.com/containous/traefik";

  src = fetchFromGitHub {
    owner = "containous";
    repo = "traefik";
    rev = "v${version}";
    sha256 = "19x2shx5a6ccnc1r0jl51b9qrypzl38npdcy07352lm6jdffi8i4";
  };

  buildInputs = [ go-bindata bash ];

  buildPhase = ''
    runHook preBuild
    (
      cd go/src/github.com/containous/traefik
      bash ./script/make.sh generate

      CODENAME=$(awk -F "=" '/CODENAME=/ { print $2}' script/binary)
      go build -ldflags "\
        -X github.com/containous/traefik/version.Version=${version} \
        -X github.com/containous/traefik/version.Codename=$CODENAME \
      " -a -o $bin/bin/traefik ./cmd/traefik
    )
    runHook postBuild
  '';

  meta = with stdenv.lib; {
    homepage = https://traefik.io;
    description = "A modern reverse proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ hamhut1066 vdemeester ];
  };
}
