{ lib, stdenv, fetchurl, fetchDebianPatch
, autoconf, gtkmm3, glib, pdftk, pkg-config, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pdfchain";
  version = "0.4.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    hash = "sha256-Hu4Pk9voyc75+f5OwKEOCkXKjN5nzWzv+izmyEN1Lz0=";
  };

  nativeBuildInputs = [
    pkg-config wrapGAppsHook autoconf
  ];

  buildInputs = [
    gtkmm3 pdftk glib
  ];

  patches = let
    fetchDebianPatch' = args: fetchDebianPatch ({
      inherit pname;
      version = "1:0.4.4.2";
      debianRevision = "2";
    } // args);
  in
  [
    (fetchDebianPatch' {
      patch = "fix_crash_on_startup";
      hash = "sha256-1UyMHHGrmUIFhY53ILdMMsyocSIbcV6CKQ7sLVNhNQw=";
    })
    (fetchDebianPatch' {
      patch = "fix_desktop_file";
      hash = "sha256-L6lhUs7GqVN1XOQO6bbz6BT29n4upsJtlHCAIGzk1Bw=";
    })
    (fetchDebianPatch' {
      patch = "fix_spelling";
      hash = "sha256-sOUUslPfcOo2K3zuaLcux+CNdgfWM0phsfe6g4GUFes=";
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
    platforms = platforms.unix;
    mainProgram = "pdfchain";
  };
}
