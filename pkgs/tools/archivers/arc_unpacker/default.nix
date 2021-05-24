{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, boost, libpng, libjpeg, zlib
, openssl, libwebp, catch }:

stdenv.mkDerivation rec {
  pname = "arc_unpacker-unstable";
  version = "2019-01-28";

  src = fetchFromGitHub {
    owner = "vn-tools";
    repo = "arc_unpacker";
    # Since the latest release (0.11) doesn't build, we've opened an upstream
    # issue in https://github.com/vn-tools/arc_unpacker/issues/187 to ask if a
    # a new release is upcoming
    rev = "b9843a13e2b67a618020fc12918aa8d7697ddfd5";
    sha256 = "0wpl30569cip3im40p3n22s11x0172a3axnzwmax62aqlf8kdy14";
  };

  nativeBuildInputs = [ cmake makeWrapper catch ];
  buildInputs = [ boost libpng libjpeg zlib openssl libwebp ];

  patches = [
    # Add a missing `<stdexcept>` import that caused the build to fail.
    # Failure: https://hydra.nixos.org/build/141997371/log
    # Also submitted as an upstream PR: https://github.com/vn-tools/arc_unpacker/pull/194
    ./add-missing-import.patch
  ];

  postPatch = ''
    cp ${catch}/include/catch/catch.hpp tests/test_support/catch.h
  '';

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

  doCheck = true;

  meta = with lib; {
    description = "A tool to extract files from visual novel archives";
    homepage = "https://github.com/vn-tools/arc_unpacker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ midchildan ];
  };
}
