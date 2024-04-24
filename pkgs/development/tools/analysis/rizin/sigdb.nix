{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "rizin-sigdb";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "rizinorg";
    # sigdb-source: source files (.pat and etc), around 2.5gb total
    # sigdb: built and deflated .sig files, around 50mb total
    repo = "sigdb";
    rev = "4addbed50cd3b50eeef5a41d72533d079ebbfbf8";
    hash = "sha256-Fy92MTuLswEgQ/XEUExqdU1Z4a5MP2Ahzi/gGxd5BtA=";
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
