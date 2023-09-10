{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "rizin-sigdb";
  version = "unstable-2023-02-13";

  src = fetchFromGitHub {
    owner = "rizinorg";
    # sigdb-source: source files (.pat and etc), around 2.5gb total
    # sigdb: built and deflated .sig files, around 50mb total
    repo = "sigdb";
    rev = "829baf835e3515923266898fd597f7f75046ebd2";
    hash = "sha256-zvGna2CEsDctc9P7hWTaz7kdtxAtPsXHNWOrRQ9ocdc=";
  };

  buildPhase = ''
    mkdir installdir
    cp -r elf pe installdir
    .scripts/verify-sigs-install.sh
  '';

  installPhase = ''
    mkdir -p $out/share/rizin
    mv installdir $out/share/rizin/sigdb
  '';

  meta = with lib; {
    description = "Rizin FLIRT Signature Database";
    homepage = src.meta.homepage;
    license = licenses.lgpl3;
    maintainers = with lib.maintainers; [ chayleaf ];
  };
}
