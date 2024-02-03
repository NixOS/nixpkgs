{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, gettext
, libtool
, pkg-config
, djvulibre
, exiv2
, fontconfig
, graphicsmagick
, libjpeg
, libuuid
, poppler
}:

stdenv.mkDerivation rec {
  version = "0.9.19";
  pname = "pdf2djvu";

  src = fetchFromGitHub {
    owner = "jwilk";
    repo = "pdf2djvu";
    rev = version;
    sha256 = "sha256-j4mYdmLZ56qTA1KbWBjBvyTyLaeuIITKYsALRIO7lj0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

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

  # Required by Poppler on darwin
  # https://github.com/jwilk/pdf2djvu/commit/373e065faf2f0d868a3700788d20a96e9528bb12
  CXXFLAGS = "-std=c++17";

  meta = with lib; {
    description = "Creates djvu files from PDF files";
    homepage = "https://jwilk.net/software/pdf2djvu";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "pdf2djvu";
  };
}
