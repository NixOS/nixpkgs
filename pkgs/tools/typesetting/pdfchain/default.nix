{ lib, stdenv, fetchurl, fetchpatch
, autoconf, gtkmm3, glib, pdftk, pkg-config, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pdfchain";
  version = "0.4.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Hu4Pk9voyc75+f5OwKEOCkXKjN5nzWzv+izmyEN1Lz0=";
  };

  nativeBuildInputs = [
    pkg-config wrapGAppsHook autoconf
  ];

  buildInputs = [
    gtkmm3 pdftk glib
  ];

  patches = let
    fetchDebianPatch = {name, sha256}: fetchpatch {
      url = "https://salsa.debian.org/debian/pdfchain/raw/2d29107756a3194fb522bdea8e9b9e393b15a8f3/debian/patches/${name}";
      inherit name sha256;
    };
  in
  [
    (fetchDebianPatch {
      name = "fix_crash_on_startup";
      sha256 = "sha256-1UyMHHGrmUIFhY53ILdMMsyocSIbcV6CKQ7sLVNhNQw=";
    })
    (fetchDebianPatch {
      name = "fix_desktop_file";
      sha256 = "sha256-L6lhUs7GqVN1XOQO6bbz6BT29n4upsJtlHCAIGzk1Bw=";
    })
    (fetchDebianPatch {
      name = "fix_spelling";
      sha256 = "sha256-sOUUslPfcOo2K3zuaLcux+CNdgfWM0phsfe6g4GUFes=";
    })
  ];

  postPatch = ''
    substituteInPlace src/constant.h \
        --replace '"pdftk"' '"${pdftk}/bin/pdftk"' \
        --replace "/usr/share" "$out/share"
  '';

  meta = with lib; {
    description = "A graphical user interface for the PDF Toolkit (PDFtk)";
    homepage = "https://pdfchain.sourceforge.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hqurve ];
    platforms = platforms.linux;
  };
}
