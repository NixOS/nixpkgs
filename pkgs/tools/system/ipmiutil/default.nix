{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  baseName = "ipmiutil";
  version = "2.9.3";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/${baseName}/${name}.tar.gz";
    sha256 = "1dwyxp4jn5wxzyahd0x839kj1q7z6xin1wybpx9na4xsgscj6v27";
  };

  buildInputs = [ openssl ];

  preBuild = ''
    sed -e "s@/usr@$out@g" -i Makefile */Makefile */*/Makefile
    sed -e "s@/etc@$out/etc@g" -i Makefile */Makefile */*/Makefile
    sed -e "s@/var@$out/var@g" -i Makefile */Makefile */*/Makefile
  '';

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = with stdenv.lib; {
    description = "An easy-to-use IPMI server management utility";
    homepage = http://ipmiutil.sourceforge.net/;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://sourceforge.net/projects/ipmiutil/files/ipmiutil/";
    };
  };
}
