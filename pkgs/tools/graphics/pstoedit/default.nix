{
  stdenv,
  fetchurl,
  pkg-config,
  darwin,
  lib,
  zlib,
  ghostscript,
  imagemagick,
  plotutils,
  gd,
  libjpeg,
  libwebp,
  libiconv,
}:
stdenv.mkDerivation rec {
  pname = "pstoedit";
  version = "4.01";

  src = fetchurl {
    url = "mirror://sourceforge/pstoedit/pstoedit-${version}.tar.gz";
    sha256 = "sha256-RZdlq3NssQ+VVKesAsXqfzVcbC6fz9IXYRx9UQKxB2s=";
  };

  outputs = [
    "out"
    "dev"
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      zlib
      ghostscript
      imagemagick
      plotutils
      gd
      libjpeg
      libwebp
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        libiconv
        ApplicationServices
      ]
    );

  meta = with lib; {
    description = "Translates PostScript and PDF graphics into other vector formats";
    homepage = "https://sourceforge.net/projects/pstoedit/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.unix;
    mainProgram = "pstoedit";
  };
}
