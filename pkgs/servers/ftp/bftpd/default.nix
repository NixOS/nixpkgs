{ stdenv, fetchurl }:

let
  pname = "bftpd";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "5.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${name}/${name}.tar.gz";
    sha256 = "1kk5xs9w6cy3yf3yqzls80vxzy0a8zxvhq854wm21pz2grn3n5yh";
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
