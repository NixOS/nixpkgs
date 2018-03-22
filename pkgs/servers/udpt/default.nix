{ stdenv, fetchFromGitHub, boost, sqlite, cmake, gtest }:

stdenv.mkDerivation rec {
  name = "udpt-${version}";
  version = "2017-09-27";

  enableParallelBuilding = true;

  # Suitable for a network facing daemon.
  hardeningEnable = [ "pie" ];

  src = fetchFromGitHub {
    owner = "naim94a";
    repo = "udpt";
    rev = "e0dffc83c8ce76b08a41a4abbd5f8065535d534f";
    sha256 = "187dw96mzgcmh4k9pvfpb7ckbb8d4vlikamr2x8vkpwzgjs3xd6g";
  };

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  buildInputs = [ boost sqlite cmake gtest ];

  postPatch = ''
    # Enabling optimization (implied by fortify hardening) causes htons
    # to be re-defined as a macro, turning this use of :: into a syntax error.
    sed -i '104a#undef htons' src/udpTracker.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc/
    cp udpt $out/bin
    cp ../udpt.conf $out/etc/
    # without this, the resulting binary is unstripped.
    runHook postInstall
  '';

  meta = {
    description = "A lightweight UDP torrent tracker";
    homepage = https://naim94a.github.io/udpt;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
