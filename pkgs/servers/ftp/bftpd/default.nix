{ stdenv, fetchurl }:

let
  pname = "bftpd";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "5.4";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${name}/${name}.tar.gz";
    sha256 = "19fd9r233wkjk8gdxn6qsjgfijiw67a48xhgbm2kq46bx80yf3pg";
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

  meta = with stdenv.lib; {
    inherit version;
    description = "A minimal ftp server";
    downloadPage = "http://bftpd.sf.net/download.html";
    homepage = http://bftpd.sf.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
