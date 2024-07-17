{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  btrfs-progs,
  gpgme,
  lvm2,
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

  buildInputs = lib.optionals stdenv.isLinux [
    btrfs-progs
    gpgme
    lvm2
  ];

  patches = [
    # fix scrolling
    # See https://github.com/wagoodman/dive/pull/447
    (fetchpatch {
      name = "fix-scrolling.patch";
      url = "https://github.com/wagoodman/dive/pull/473/commits/a885fa6e68b3763d52de20603ee1b9cd8949276f.patch";
      hash = "sha256-6gTWfyvK19xDqc7Ah33ewgz/WQRcQHLYwerrwUtRpJc=";
    })
    (fetchpatch {
      name = "add-scrolling-layers.patch";
      url = "https://github.com/wagoodman/dive/pull/473/commits/840653158e235bdd59b4c4621cf282ce6499c714.patch";
      hash = "sha256-dYqg5JpWKOzy3hVjIVCHA2vmKCtCgc8W+oHEzuGpyxc=";
    })
    (fetchpatch {
      name = "fix-render-update.patch";
      url = "https://github.com/wagoodman/dive/pull/473/commits/36177a9154eebe9e3ae9461a9e6f6b368f7974e1.patch";
      hash = "sha256-rSeEYxUaYlEZGv+NWYK+nATBYS4P2swqjC3HimHyqNI=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "A tool for exploring each layer in a docker image";
    mainProgram = "dive";
    homepage = "https://github.com/wagoodman/dive";
    changelog = "https://github.com/wagoodman/dive/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
