{ stdenv, buildGoModule, fetchFromGitHub, go-bindata, nixosTests, fetchpatch }:

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

  patches = [
    (fetchpatch {
      name = "CVE-2021-27375.patch";
      url = "https://github.com/traefik/traefik/commit/bae28c5f5717ea3a80423f107fefe6948c14b7cd.patch";
      sha256 = "0gbygblzc6l0rywznbl6in2h5mjk5d0x0aq6pqgag2vrjbyk9kfi";
    })
  ];

  doCheck = false;

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
