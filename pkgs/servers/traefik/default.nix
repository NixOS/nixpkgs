{ stdenv, buildGoModule, fetchFromGitHub, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "containous";
    repo = "traefik";
    rev = "v${version}";
    sha256 = "0byi2h1lma95l77sdj8jkidmwb12ryjqwxa0zz6vwjg07p5ps3k4";
  };

  modSha256 = "17imp24abfgh75g8161daknzqzk2m19q9d1mij6487046lk75hqz";
  subPackages = [ "cmd/traefik" ];

  nativeBuildInputs = [ go-bindata ];

  passthru.tests = { inherit (nixosTests) traefik; };

  preBuild = ''
    go generate

    CODENAME=$(awk -F "=" '/CODENAME=/ { print $2}' script/binary)

    makeFlagsArray+=("-ldflags=\
      -X github.com/containous/traefik/version.Version=${version} \
      -X github.com/containous/traefik/version.Codename=$CODENAME")
  '';

  meta = with stdenv.lib; {
    homepage = "https://traefik.io";
    description = "A modern reverse proxy";
    license = licenses.mit;
    maintainers = with maintainers; [ vdemeester ];
  };
}
