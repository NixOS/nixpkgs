{ stdenv, fetchFromGitHub, fetchurl, makeWrapper
, dtapi, curl, linuxHeaders }:

stdenv.mkDerivation rec {
  pname = "tsduck";
  version = "3.19-1520";

  src = fetchFromGitHub {
    owner = "tsduck";
    repo = "tsduck";
    rev = "v${version}";
    sha256 = "1w7qq4hjk144dwqhfrkbf7qgz1i8pf8z8phyk9gwc4yd9i5rx8an";
  };

  postPatch = ''
    patchShebangs .

    # Provide patched dtapi
    mkdir -p dektec/LinuxSDK/DTAPI
    cp -r ${dtapi}/* dektec/LinuxSDK/DTAPI/

    # Disable automatic downloading or unpacking of dtapi
    sed -i 's/^dtapi:.*/dtapi:/g' dektec/Makefile
  '';

  buildInputs = [ curl linuxHeaders ];
  nativeBuildInputs = [ curl makeWrapper ]; # Makefile calls curl-config

  makeFlags = [
    # Disable smartcard support, removes pcsc-lite dependency
    "NOPCSC=1"
    # Yes, it will not find it otherwise
    "LDFLAGS_EXTRA=${dtapi}/Lib/GCC5.1_CXX11_ABI1/DTAPI64.o"
  ];

  installFlags = [ "SYSROOT=$(out)" ];

  postInstall = ''
    # Some LSB stuff
    rm -r $out/etc/security

    # /usr
    mv $out/usr/* $out
    rmdir $out/usr

    # non-executables in bin
    mkdir $out/lib
    mv $out/bin/*.so $out/bin/*.xml $out/bin/*.names $out/lib

    # Wrap to add lib to search path
    for prog in $out/bin/*; do
      wrapProgram "$prog" \
        --prefix LD_LIBRARY_PATH : "$out/lib" \
        --prefix TSPLUGINS_PATH : "$out/lib"
    done
  '';

  meta = with stdenv.lib; {
    description = "An extensible toolkit for MPEG/DVB transport streams";
    homepage = "https://tsduck.io/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
