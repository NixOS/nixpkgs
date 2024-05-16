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

  patches = [
    (fetchpatch {
      name = "add-scrolling-layers.patch";
      url = "https://github.com/wagoodman/dive/pull/478/commits/b7da0f90880ce5e9d3bc2d0f269aadac6ee63c49.patch";
      hash = "sha256-dYqg5JpWKOzy3hVjIVCHA2vmKCtCgc8W+oHEzuGpyxc=";
    })
    (fetchpatch {
      name = "fix-render-update.patch";
      url = "https://github.com/wagoodman/dive/pull/478/commits/326fb0d8c9094ac068a29fecd4f103783199392c.patch";
      hash = "sha256-NC74MqHVChv/Z5hHX8ds3FI+tC+yyBpXvZKSFG3RyC0=";
    })
  ];


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
