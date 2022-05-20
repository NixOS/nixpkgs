{ lib
, stdenvNoCC
, fetchFromGitHub
, bash
, makeWrapper
, bc
, jq
, coreutils
, util-linux
, wimlib
, file
, syslinux
, busybox
, gnugrep # We can't use busybox's 'grep' as it doesn't support perl '-P' expressions.
}:

stdenvNoCC.mkDerivation rec {
  pname = "bootiso";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "jsamr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l09d543b73r0wbpsj5m6kski8nq48lbraq1myxhidkgl3mm3d5i";
  };

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/bootiso \
      --prefix PATH : ${lib.makeBinPath [ bc jq coreutils util-linux wimlib file syslinux gnugrep busybox ]} \
      --prefix BOOTISO_SYSLINUX_LIB_ROOT : ${syslinux}/share/syslinux
  '';

  meta = with lib; {
    description = "Script for securely creating a bootable USB device from one image file";
    homepage = "https://github.com/jsamr/bootiso";
    license = licenses.gpl3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.all;
  };
}
