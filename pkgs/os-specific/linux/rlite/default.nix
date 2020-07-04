{ stdenv
, fetchFromGitHub
, which
, kmod
, kernel
, protobuf
, cmake
, python
, swig
, wpa_supplicant
, hostapd
, enable-python ? false
, enable-wifi ? false
}:
let
  deps = [ which cmake protobuf ];
  meta = with stdenv.lib; {
    description = "A light RINA implementation";
    homepage    = https://github.com/rlite/rlite;
    license     = licenses.lgpl21;
    maintainers = [ maintainers.twey ];
    platforms   = platforms.linux;
  };
in stdenv.mkDerivation rec {
  pname = "rlite";
  version = "2020-03-31";
  src = fetchFromGitHub {
    owner = "rlite";
    repo = pname;
    rev = "0612ddd2423bb00225a573e78194ed7eaafc5604";
    sha256 = "1gngcxxl792lqpwdvxqzlajgx3rgxaksxdbj55hjcr4d3qiqq905";
  };

  buildInputs = stdenv.lib.concatLists [
    deps
    (stdenv.lib.optionals enable-python [ python swig ])
    (stdenv.lib.optionals enable-wifi [ wpa_supplicant hostapd ])
  ];

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
}
