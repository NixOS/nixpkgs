{ lib
, stdenv
, fetchFromGitHub
, fuse
, libarchive
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "fuse-archive";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fuse-archive";
    rev = "refs/tags/v${version}";
    hash = "sha256-l4tIK157Qo4m611etwMSk564+eC28x4RbmjX3J57/7Q=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse
    libarchive
  ];

  env.NIX_CFLAGS_COMPILE = "-D_FILE_OFFSET_BITS=64";

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Serve an archive or a compressed file as a read-only FUSE file system";
    homepage = "https://github.com/google/fuse-archive";
    changelog = "https://github.com/google/fuse-archive/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ icyrockcom ];
    mainProgram = "fuse-archive";
  };

  inherit (fuse.meta) platforms;
}
