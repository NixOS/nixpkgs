{ fetchurl, stdenv, makeWrapper, perl, perlPackages }:


stdenv.mkDerivation rec {
  name = "amtterm-${version}";
  version = "1.6-1";
  
  buildInputs = with perlPackages; [ perl SOAPLite ];
  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "https://www.kraxel.org/cgit/amtterm/snapshot/${name}.tar.gz";
    sha256 = "1jxcsqkag2bxmrnr4m6g88sln1j2d9liqlna57fj8kkc85316vlc";
  };

  makeFlags = [ "prefix=$(out)" ];

  postInstall =
    "wrapProgram $out/bin/amttool --prefix PERL5LIB : $PERL5LIB";

  meta = with stdenv.lib;
    { description = "Intel AMT® SoL client + tools";
      homepage = https://www.kraxel.org/cgit/amtterm/;
      license = licenses.gpl2;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
