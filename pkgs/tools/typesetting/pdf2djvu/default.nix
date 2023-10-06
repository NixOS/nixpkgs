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
  version = "0.9.18.2";
  pname = "pdf2djvu";

  src = fetchFromGitHub {
    owner = "jwilk";
    repo = "pdf2djvu";
    rev = version;
    sha256 = "s6n7nDO15DZSJ1EOPoNvjdFv/QtOoGiUa2b/k3kzWe8=";
  };

  patches = [
    # Fix build with Poppler 22.03.
    (fetchpatch {
      url = "https://github.com/jwilk/pdf2djvu/commit/e170ad557d5f13daeeac047dfaa79347bbe5062f.patch";
      sha256 = "OPK2UWVs+E2uOEaxPtLWmVL28yCxaeJKscY9ziAbS7E=";
    })
    (fetchpatch {
      url = "https://github.com/jwilk/pdf2djvu/commit/956fedc7e0831126b9006efedad5519c14201c52.patch";
      sha256 = "JF1xvvL2WyMu6GjdrPLlRC6eC6vGLbVurQcNy3AOOXA=";
    })
    (fetchpatch {
      url = "https://github.com/jwilk/pdf2djvu/commit/dca43e8182174bc04e107eaefcafcfdfdf9bcd61.patch";
      sha256 = "0JcfDaVZpuv6VfUJ2HuxRqgntZ/t8AzU0RG/E83BWGY=";
    })
    (fetchpatch {
      url = "https://github.com/jwilk/pdf2djvu/commit/81b635e014ebd0240a8719cc39b6a1b759cc6a98.patch";
      sha256 = "LBmT4eflLd23X7gg7IbqGe3PfTGldEGFLEKImV4nbB0=";
      postFetch = ''
        # The file was renamed after the release.
        sed -i "s/main.cc/pdf2djvu.cc/g" "$out"
      '';
    })
  ];

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

  # Required by Poppler
  # https://github.com/jwilk/pdf2djvu/commit/373e065faf2f0d868a3700788d20a96e9528bb12
  CXXFLAGS = "-std=c++17";

  meta = with lib; {
    description = "Creates djvu files from PDF files";
    homepage = "https://jwilk.net/software/pdf2djvu";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
