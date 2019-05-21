{ stdenv, fetchFromGitHub, automake, gcc, zlib, libpng, libjpeg
 , freetype, libX11, libXext, buildPackages, yacc, flex }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "unstable-2019-05-20";
  pname = "microwindows";

  src = fetchFromGitHub {
    owner = "ghaerr";
    repo = "microwindows";
    rev = "ad3164ddd42fb28761a04ec69534e4486a5894f8";
    sha256 = "0qddkzwax96i0g73ir378s37b3xhihpz2146a3yph4l2p6lcdd8i";
  };

  sourceRoot = "source/src";

  patchPhase = ''
    cp Configs/config.linux-X11 config
    # canceled failing demo
    substituteInPlace demos/nuklear/Makefile --replace "all:" "#all:"
  '';

  nativeBuildInputs = [ gcc ];
  depsBuildBuild = [ automake yacc flex buildPackages.stdenv.cc ];
  buildInputs = [ libpng libjpeg freetype libX11 libXext zlib ];

  makeFlags = [
    "HOSTCC=gcc"
    "LEX=flex"
    "HAVE_JPEG_SUPPORT=Y"
    "INSTALL_PREFIX=${placeholder "out"}"
    "INSTALL_OWNER1= INSTALL_OWNER2="
  ];

  # copy missing binaries
  postInstall = ''
    cp bin/* $out/bin
  '';

  postFixup =
  ''
      find "$out/bin" -executable -exec \
      patchelf \
      --replace-needed /build/source/src/lib/libnano-X.so "$out/lib/libnano-X.so" \
      --replace-needed /build/source/src/lib/libmwin.so "$out/lib/libmwin.so" \
      {} \;
  '';

  meta = with stdenv.lib; {
    description = "A small graphical windowing system";
    homepage = "http://microwindows.org";
    license = licenses.mpl11;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
