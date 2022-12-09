{ lib
, stdenv
, fetchurl

# build
, meson
, ninja
, pkg-config

# docs
, sphinx

# runtime
, buildPackages
, ffmpeg_5-headless

# tests
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "unpaper";
  version = "7.0.0";

  src = fetchurl {
    url = "https://www.flameeyes.eu/files/${pname}-${version}.tar.xz";
    hash = "sha256-JXX7vybCJxnRy4grWWAsmQDH90cRisEwiD9jQZvkaoA=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    buildPackages.libxslt.bin
    meson
    ninja
    pkg-config
    sphinx
  ];

  buildInputs = [
    ffmpeg_5-headless
  ];

  passthru.tests = {
    inherit (nixosTests) paperless;
  };

  meta = with lib; {
    homepage = "https://www.flameeyes.eu/projects/unpaper";
    description = "Post-processing tool for scanned sheets of paper";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
