{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch
, pkg-config
, btrfs-progs
, gpgme
, lvm2
}:

buildGoModule rec {
  pname = "dive";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "wagoodman";
    repo = "dive";
    rev = "v${version}";
    hash = "sha256-CuVRFybsn7PVPgz3fz5ghpjOEOsTYTv6uUAgRgFewFw=";
  };

  vendorHash = "sha256-uzzawa/Doo6j/Fh9dJMzGKbpp24UTLAo9VGmuQ80IZE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ btrfs-progs gpgme lvm2 ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    mainProgram = "dive";
    homepage = "https://github.com/wagoodman/dive";
    changelog = "https://github.com/wagoodman/dive/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
