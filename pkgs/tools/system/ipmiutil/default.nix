{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  baseName = "ipmiutil";
  version = "3.0.9";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/${baseName}/${name}.tar.gz";
    sha256 = "0j4lsfdj2bk1b1vw9l00zv1g4jan05p09szqbzxgqqw2lpnca4i7";
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
