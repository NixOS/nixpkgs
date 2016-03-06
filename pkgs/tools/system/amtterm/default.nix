{ fetchurl, stdenv, makeWrapper, perl, perlPackages }:

let version = "1.4"; in
stdenv.mkDerivation {
  name = "amtterm-"+version;

  buildInputs = with perlPackages; [ perl SOAPLite ];
  nativeBuildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "https://www.kraxel.org/cgit/amtterm/snapshot/amtterm-a75e48e010e92dc5540e2142efc445ccb0ab1a42.tar.gz";
    sha256 = "0i4ny5dyf3fy3sd65zw9v4xxw3rc3qyn8r8y8gwwgankj6iqkqp4";
  };

  makeFlags = [ "prefix=$(out)" ];

  postInstall =
    "wrapProgram $out/bin/amttool --prefix PERL5LIB : $PERL5LIB";

  meta = with stdenv.lib;
    { description = "Intel AMT® SoL client + tools";
      homepage = "https://www.kraxel.org/cgit/amtterm/";
      license = licenses.gpl2;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
