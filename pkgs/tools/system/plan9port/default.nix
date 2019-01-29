{ stdenv, fetchgit, which, libX11, libXt, fontconfig, freetype
, xorgproto ? null
, libXext ? null
, zlib ? null
  # For building web manuals
, perl ? null
, samChordingSupport ? true #from 9front
}:

stdenv.mkDerivation rec {
  name = "plan9port-2018-09-20";

  src = fetchgit {
    # Latest, same as on github, google code is old
    url = "https://github.com/9fans/plan9port.git";
    rev = "a82a8b6368274d77d42f526e379b74e79c137e26";
    sha256 = "1icywcnqv0dz1mkm7giakii536nycp0ajxnmzkx4944dxsmhcwq1";
  };

  patches = stdenv.lib.optionals samChordingSupport [ ./sam_chord_9front.patch ];

  postPatch = ''
    #hardcoded path
    substituteInPlace src/cmd/acme/acme.c \
      --replace /lib/font/bit $out/plan9/font
    #deprecated flags
    find . -type f \
      -exec sed -i -e 's/_SVID_SOURCE/_DEFAULT_SOURCE/g' {} \; \
      -exec sed -i -e 's/_BSD_SOURCE/_DEFAULT_SOURCE/g' {} \;
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    #add missing ctrl+c\z\x\v keybind for non-Darwin
    substituteInPlace src/cmd/acme/text.c \
      --replace "case Kcmd+'c':" "case 0x03: case Kcmd+'c':" \
      --replace "case Kcmd+'z':" "case 0x1a: case Kcmd+'z':" \
      --replace "case Kcmd+'x':" "case 0x18: case Kcmd+'x':" \
      --replace "case Kcmd+'v':" "case 0x16: case Kcmd+'v':"
  '';

  builder = ./builder.sh;

  NIX_LDFLAGS="-lgcc_s";
  buildInputs = stdenv.lib.optionals (!stdenv.isDarwin) [
    which
    perl
    libX11
    fontconfig
    xorgproto
    libXt
    libXext
    freetype #fontsrv wants ft2build.h. provides system fonts for acme and sam.
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://swtch.com/plan9port/;
    description = "Plan 9 from User Space";
    license = licenses.lpl-102;
    maintainers = with maintainers; [ bbarker ftrvxmtrx kovirobi ];
    platforms = platforms.unix;
  };
  
  libX11_dev = libX11.dev;
  libXt_dev = libXt.dev;
  libXext_dev = libXext.dev;
  fontconfig_dev = fontconfig.dev;
  freetype_dev = freetype.dev;
  zlib_dev = zlib.dev;
  
  xorgproto_exp = xorgproto;
  libX11_exp = libX11;
  libXt_exp = libXt;
  libXext_exp = libXext;
  freetype_exp = freetype;
  zlib_exp = zlib;

  fontconfig_lib = fontconfig.lib;
}
