{ stdenv, buildGoModule, fetchFromGitHub, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "containous";
    repo = "traefik";
    rev = "v${version}";
    sha256 = "1p2qv8vrjxn5wg41ywxbpaghb8585xmkwr8ih5df4dbdjw2m3k1f";
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
