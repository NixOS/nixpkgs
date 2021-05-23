{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, boost, libpng, libiconv
, libjpeg, zlib, openssl, libwebp, catch }:

stdenv.mkDerivation rec {
  pname = "arc_unpacker";
  version = "unstable-2021-05-17";

  src = fetchFromGitHub {
    owner = "vn-tools";
    repo = "arc_unpacker";
    # Since the latest release (0.11) doesn't build, we've opened an upstream
    # issue in https://github.com/vn-tools/arc_unpacker/issues/187 to ask if a
    # a new release is upcoming
    rev = "9c2781fcf3ead7641e873b65899f6abeeabb2fc8";
    sha256 = "1xxrc9nww0rla3yh10z6glv05ax4rynwwbd0cdvkp7gyqzrv97xp";
  };

  nativeBuildInputs = [ cmake makeWrapper catch ];
  buildInputs = [ boost libpng libjpeg zlib openssl libwebp ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ];

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

  # A few tests fail on aarch64
  doCheck = !stdenv.isAarch64;

  meta = with lib; {
    description = "A tool to extract files from visual novel archives";
    homepage = "https://github.com/vn-tools/arc_unpacker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.all;
  };
}
