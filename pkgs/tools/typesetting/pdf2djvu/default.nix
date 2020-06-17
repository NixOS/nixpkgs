{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, gettext
, libtool
, pkgconfig
, djvulibre
, exiv2
, fontconfig
, graphicsmagick
, libjpeg
, libuuid
, poppler
}:

stdenv.mkDerivation rec {
  version = "0.9.17";
  pname = "pdf2djvu";

  src = fetchFromGitHub {
    owner = "jwilk";
    repo = "pdf2djvu";
    rev = version;
    sha256 = "1iff5ha5ls9hni9ivj05r1vzbnjrb326ivjb8d05q2sfng3gfp3z";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [
    djvulibre
    exiv2
    fontconfig
    graphicsmagick
    libjpeg
    libuuid
    poppler
  ];

  postPatch = ''
    substituteInPlace private/autogen \
      --replace /usr/share/gettext ${gettext}/share/gettext \
      --replace /usr/share/libtool ${libtool}/share/libtool

    substituteInPlace configure.ac \
      --replace '$djvulibre_bin_path' ${djvulibre.bin}/bin
  '';

  preAutoreconf = ''
    private/autogen
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Creates djvu files from PDF files";
    homepage = "https://jwilk.net/software/pdf2djvu";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    inherit version;
  };
}
