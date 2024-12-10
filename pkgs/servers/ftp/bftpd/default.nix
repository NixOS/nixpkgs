{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "bftpd";
  version = "6.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-lZGFsUV6LNjkBNUpV9UYedVt1yt1qTBJUorxGt4ApsI=";
  };

  # utmp.h is deprecated on aarch64-darwin
  postPatch = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) ''
    for file in login.*; do
      substituteInPlace $file --replace "#ifdef HAVE_UTMP_H" "#if 0"
    done
  '';

  buildInputs = [ libxcrypt ];

  CFLAGS = "-std=gnu89";

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
    mainProgram = "bftpd";
    downloadPage = "http://bftpd.sf.net/download.html";
    homepage = "http://bftpd.sf.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };
}
