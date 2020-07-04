{ cmake
, fetchFromGitHub
, hostapd
, kernel
, kmod
, lib
, protobuf
, python
, stdenv
, swig
, which
, wpa_supplicant
, enable-python ? false
, enable-wifi ? false
}:
stdenv.mkDerivation rec {
  pname = "rlite";
  version = "2020-03-31";
  src = fetchFromGitHub {
    owner = "rlite";
    repo = pname;
    rev = "0612ddd2423bb00225a573e78194ed7eaafc5604";
    sha256 = "1gngcxxl792lqpwdvxqzlajgx3rgxaksxdbj55hjcr4d3qiqq905";
  };

  buildInputs = [ which cmake protobuf ]
    ++ stdenv.lib.optionals enable-python [ python swig ]
    ++ stdenv.lib.optionals enable-wifi [ wpa_supplicant hostapd ];

  patches = [
    ./configure-remove-hardcoded-paths.patch
    ./strip-hardcoded-usr-install-prefix.patch
  ];

  postUnpack = "patchShebangs .";
  configurePhase = ''
    ./configure \
      --prefix $out \
      --kernbuilddir "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" \
  '';
  buildPhase = "make -j$NIX_BUILD_CORES";
  installPhase = "make install";

  meta = {
    description = "A light RINA implementation";
    homepage    = https://github.com/rlite/rlite;
    license     = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ twey ];
    platforms   = lib.platforms.linux;
  };

}
