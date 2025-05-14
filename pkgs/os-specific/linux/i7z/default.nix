{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
  withGui ? false,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "i7z";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "DimitryAndric";
    repo = "i7z";
    rev = "v${version}";
    sha256 = "00c4ng30ry88hcya4g1i9dngiqmz3cs31x7qh1a10nalxn1829xy";
  };

  buildInputs = [ ncurses ] ++ lib.optional withGui qtbase;

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/i7z/raw/ad1359764ee7a860a02e0c972f40339058fa9369/debian/patches/fix-insecure-tempfile.patch";
      sha256 = "0ifg06xjw14y4fnzzgkhqm4sv9mcdzgi8m2wffq9z8b1r0znya3s";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/i7z/raw/ad1359764ee7a860a02e0c972f40339058fa9369/debian/patches/nehalem.patch";
      sha256 = "1ys6sgm01jkqb6d4y7qc3h89dzph8jjjcfya5c5jcm7dkxlzjq8a";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/debian/i7z/raw/ad1359764ee7a860a02e0c972f40339058fa9369/debian/patches/hyphen-used-as-minus-sign.patch";
      sha256 = "1ji2qvdyq0594cpqz0dlsfggvw3rm63sygh0jxvwjgxpnhykhg1p";
    })
    ./qt5.patch
  ];

  enableParallelBuilding = true;

  postBuild = lib.optionalString withGui ''
    cd GUI
    qmake
    make clean
    make
    cd ..
  '';

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = lib.optionalString withGui ''
    install -Dm755 GUI/i7z_GUI $out/bin/i7z-gui
  '';

  meta = with lib; {
    description = "Better i7 (and now i3, i5) reporting tool for Linux";
    mainProgram = "i7z";
    homepage = "https://github.com/DimitryAndric/i7z";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ bluescreen303 ];
    # broken on ARM
    platforms = [ "x86_64-linux" ];
  };
}
