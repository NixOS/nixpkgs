{ stdenv, buildGoModule, fetchFromGitHub, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "containous";
    repo = "traefik";
    rev = "v${version}";
    sha256 = "1zxifwbrhxaj2pl6kwyk1ivr4in0wd0q01x9ynxzbf6w2yx4xkw2";
  };

  vendorSha256 = "0kz7y64k07vlybzfjg6709fdy7krqlv1gkk01nvhs84sk8bnrcvn";
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
