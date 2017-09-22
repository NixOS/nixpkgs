{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  baseName = "ipmiutil";
  version = "3.0.5";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/${baseName}/${name}.tar.gz";
    sha256 = "0ppfxh04c0aj9dxpkzj3xv1kylc17k1kvqabp8r7h70k6ljzgmxj";
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
    downloadPage = "http://sourceforge.net/projects/ipmiutil/files/ipmiutil/";
    inherit version;
  };
}
