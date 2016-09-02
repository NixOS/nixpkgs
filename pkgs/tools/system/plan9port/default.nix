{ stdenv, fetchgit, which, libX11, libXt, fontconfig, freetype
, xproto ? null
, xextproto ? null
, libXext ? null
  # For building web manuals
, perl ? null
, samChordingSupport ? true #from 9front
}:

stdenv.mkDerivation rec {
  name = "plan9port-2016-04-18";

  src = fetchgit {
    # Latest, same as on github, google code is old
    url = "https://plan9port.googlesource.com/plan9";
    rev = "35d43924484b88b9816e40d2f6bff4547f3eec47";
    sha256 = "1dvg580rkav09fra2gnrzh271b4fw6bgqfv4ib7ds5k3j55ahcdc";
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
    maintainers = with maintainers; [ ftrvxmtrx kovirobi ];
    platforms = platforms.unix;
  };

  libXt_dev = libXt.dev;
  fontconfig_dev = fontconfig.dev;
  freetype_dev = freetype.dev;
}
