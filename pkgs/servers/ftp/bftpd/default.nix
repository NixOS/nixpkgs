{ lib, stdenv, fetchurl, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "bftpd";
  version = "6.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-lyHQYU4aXQ/muAyaigStqO/ULL393SOelagFmuKDqm8=";
  };

  # utmp.h is deprecated on aarch64-darwin
  postPatch = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) ''
    for file in login.*; do
      substituteInPlace $file --replace "#ifdef HAVE_UTMP_H" "#if 0"
    done
  '';

  buildInputs = [ libxcrypt ];

  preConfigure = ''
    sed -re 's/-[og] 0//g' -i Makefile*
  '';

  postInstall = ''
    mkdir -p $out/share/doc/${pname}
    mv $out/etc/*.conf $out/share/doc/${pname}
    rm -rf $out/{etc,var}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A minimal ftp server";
    downloadPage = "http://bftpd.sf.net/download.html";
    homepage = "http://bftpd.sf.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
