{ lib
, stdenv
, cscope
, fetchFromGitHub
, fetchpatch
, git
, libevent
, libopus
, libsodium
, libtoxcore
, libvpx
, msgpack
, pkg-config
, python3
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "tuntox";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "gjedeer";
    repo = pname;
    rev = version;
    sha256 = "sha256-c/0OxUH8iw8nRuVg4Fszf6Z/JiEV+m0B2ofzy81uFu8=";
  };

  nativeBuildInputs = [ cscope git pkg-config ];

  buildInputs = [ libopus libtoxcore libsodium libevent libvpx msgpack python3 ];

  pythonBuildInputs = with python3Packages; [
    jinja2
    requests
  ];

  patches = [
    # https://github.com/gjedeer/tuntox/pull/67
    (fetchpatch {
      url = "https://github.com/gjedeer/tuntox/compare/a646402f42e120c7148d4de29dbdf5b09027a80a..365d2e5cbc0e3655fb64c204db0515f5f4cdf5a4.patch";
      sha256 = "sha256-P3uIRnV+pBi3s3agGYUMt2PZU4CRxx/DUR8QPVQ+UN8=";
    })
  ];

  postPatch = ''
      substituteInPlace gitversion.h --replace '7d45afdf7d00a95a8c3687175e2b1669fa1f7745' '365d2e5cbc0e3655fb64c204db0515f5f4cdf5a4'
    '' + lib.optionalString stdenv.isLinux ''
      substituteInPlace Makefile --replace ' -static ' ' '
      substituteInPlace Makefile --replace 'CC=gcc' ' '
    '' + lib.optionalString stdenv.isDarwin ''
      substituteInPlace Makefile.mac --replace '.git/HEAD .git/index' ' '
      substituteInPlace Makefile.mac --replace '/usr/local/lib/libtoxcore.a' '${libtoxcore}/lib/libtoxcore.a'
      substituteInPlace Makefile.mac --replace '/usr/local/lib/libsodium.a' '${libsodium}/lib/libsodium.dylib'
      substituteInPlace Makefile.mac --replace 'CC=gcc' ' '
    '';

  buildPhase = ''
    '' + lib.optionalString stdenv.isLinux ''
      make
    '' + lib.optionalString stdenv.isDarwin ''
      make -f Makefile.mac tuntox
    '';

  installPhase = ''
    mkdir -p $out/bin
    mv tuntox $out/bin/
  '';

  doCheck = false;

  meta = with lib; {
    description = "Tunnel TCP connections over the Tox protocol";
    homepage = "https://github.com/gjedeer/tuntox";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      willcohen
    ];
    platforms = platforms.unix;
  };
}
