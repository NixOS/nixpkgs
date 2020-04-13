{ stdenv, buildGoModule, fetchFromGitHub, go-bindata, nixosTests }:

buildGoModule rec {
  pname = "traefik";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "containous";
    repo = "traefik";
    rev = "v${version}";
    sha256 = "1dcazssabqxr9wv3dds3z7ks3y628qa07vgnn3hpdwxzm2b2ma92";
  };

  modSha256 = "0w3ssxvsmq8i6hbfmn4ig2x13i2nlqy5q1khcblf9pq5vhk202qx";
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
