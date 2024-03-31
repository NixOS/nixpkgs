{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, makeWrapper
, boost
, libpng
, libiconv
, libjpeg
, zlib
, openssl
, libwebp
, catch2
}:

stdenv.mkDerivation {
  pname = "arc_unpacker";
  version = "unstable-2021-08-06";

  src = fetchFromGitHub {
    owner = "vn-tools";
    repo = "arc_unpacker";
    rev = "456834ecf2e5686813802c37efd829310485c57d";
    hash = "sha256-STbdWH7Mr3gpOrZvujblYrIIKEWBHzy1/BaNuh4teI8=";
  };

  patches = [
    (fetchpatch {
      name = "failing_tests.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/failing_tests.patch?h=arc_unpacker-git&id=bda1ad9f69e6802e703b2e6913d71a36d76cfef9";
      hash = "sha256-bClACsf/+SktyLAPtt7EcSqprkw8JVIi1ZLpcJcv9IE=";
    })
    (fetchpatch {
      name = "include_cstdint.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/include_cstdint.patch?h=arc_unpacker-git&id=8c5c5121b23813c7650db19cb617b409d8fdcc9f";
      hash = "sha256-3BQ1v7s9enUK/js7Jqrqo2RdSRvGVd7hMcY4iL51SiE=";
    })
  ];

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp tests/test_support/catch.h
    sed '1i#include <limits>' -i src/dec/eagls/pak_archive_decoder.cc # gcc12
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    catch2
  ];

  buildInputs = [
    boost
    libiconv
    libjpeg
    libpng
    libwebp
    openssl
    zlib
  ];

  checkPhase = ''
    runHook preCheck

    pushd ..
    ./build/run_tests
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/doc/arc_unpacker $out/libexec/arc_unpacker
    cp arc_unpacker $out/libexec/arc_unpacker/arc_unpacker
    cp ../GAMELIST.{htm,js} $out/share/doc/arc_unpacker
    cp -r ../etc $out/libexec/arc_unpacker
    makeWrapper $out/libexec/arc_unpacker/arc_unpacker $out/bin/arc_unpacker

    runHook postInstall
  '';

  # A few tests fail on aarch64-linux
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  meta = with lib; {
    description = "A tool to extract files from visual novel archives";
    homepage = "https://github.com/vn-tools/arc_unpacker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.all;
    mainProgram = "arc_unpacker";

    # unit test failures
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
