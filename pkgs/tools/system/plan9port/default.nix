{ stdenv, fetchgit, which, libX11, libXt, fontconfig, freetype
, xproto ? null
, xextproto ? null
, libXext ? null
  # For building web manuals
, perl ? null
, samChordingSupport ? true #from 9front
}:

stdenv.mkDerivation rec {
  name = "plan9port-2015-11-10";

  src = fetchgit {
    # Latest, same as on github, google code is old
    url = "https://plan9port.googlesource.com/plan9";
    rev = "0d2dfbc";
    sha256 = "1h16wvps4rfkjim2ihkmniw8wzl7yill5910larci1c70x6zcicf";
  };

  patches = [
    ./fontsrv.patch
  ] ++ stdenv.lib.optionals samChordingSupport [ ./sam_chord_9front.patch ];

  postPatch = ''
    #hardcoded path
    substituteInPlace src/cmd/acme/acme.c \
      --replace /lib/font/bit $out/plan9/font
    #deprecated flags
    find . -type f \
      -exec sed -i -e 's/_SVID_SOURCE/_DEFAULT_SOURCE/g' {} \; \
      -exec sed -i -e 's/_BSD_SOURCE/_DEFAULT_SOURCE/g' {} \;
  '';

  builder = ./builder.sh;

  NIX_LDFLAGS="-lgcc_s";
  buildInputs = stdenv.lib.optionals
                  (!stdenv.isDarwin)
                  [ which
                    perl
                    libX11
                    fontconfig
                    xproto
                    libXt
                    xextproto
                    libXext
                    freetype #fontsrv wants ft2build.h. provides system fonts for acme and sam.
                  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://swtch.com/plan9port/";
    description = "Plan 9 from User Space";
    license = licenses.lpl-102;
    maintainers = with stdenv.lib.maintainers; [ ftrvxmtrx kovirobi ];
    platforms = platforms.unix;
  };

  libXt_dev = libXt.dev;
  fontconfig_dev = fontconfig.dev;
  freetype_dev = freetype.dev;
}
