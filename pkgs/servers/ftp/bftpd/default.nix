{ lib, stdenv, fetchurl }:

let
  pname = "bftpd";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "5.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${name}/${name}.tar.gz";
    sha256 = "sha256-pUPOYqgJKntQZRRodcyYeFNLCdxKhT8sK1bi3jl6b0s=";
  };

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
