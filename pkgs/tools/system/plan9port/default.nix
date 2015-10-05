{stdenv, fetchgit, which, libX11, libXt, fontconfig
, xproto ? null
, xextproto ? null
, libXext ? null
  # For building web manuals
, perl ? null }:

stdenv.mkDerivation rec {
  name = "plan9port-2015-06-29";

  src = fetchgit {
    # Latest, same as on github, google code is old
    url = "https://plan9port.googlesource.com/plan9";
    rev = "71de840";
    sha256 = "1ffece7c0a5775a8bde6a0618c7ae3da4048449008a19e6623e8e5553f133b4c";
  };

  patches = [ ./fontsrv.patch ];
  postPatch =
    ''
      substituteInPlace src/cmd/acme/acme.c \
          --replace /lib/font/bit $out/plan9/font
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
}
