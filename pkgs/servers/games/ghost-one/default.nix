{ stdenv, fetchurl, unzip, gmp, zlib, bzip2, boost, mysql }:
stdenv.mkDerivation rec {

  name = "ghost-one-${version}";
  version = "1.7.265";

  src = fetchurl {
    url = "http://www.maxdevlon.com/ghost/ghostone${version}.zip";
    sha256 = "1sm2ca3lcdr4vjg7v94d8zhqz8cdp44rg8yinzzwkgsr0hj74fv2";
  };

  buildInputs = [ unzip gmp zlib bzip2 boost mysql ];

  patchPhase = ''
    substituteInPlace ghost/Makefile --replace "/usr/local/lib/mysql" "${mysql}/lib/mysql"
  '';

  buildPhase = ''
    cd bncsutil/src/bncsutil
    make
    cd ../../../StormLib/stormlib/
    make
    ensureDir $out/lib
    cd ../..
#    cp bncsutil/src/bncsutil/libbncutil.so $out/lib
#    cp StormLib/stormlib/libStorm.so $out/lib
    cd ghost
    make
    cd ..
  '';

  installPhase = ''
    ensureDir $out/lib
    cp bncsutil/src/bncsutil/libbncsutil.so $out/lib
    cp StormLib/stormlib/libStorm.so $out/lib

    ensureDir $out/bin
    cp ghost/ghost++ $out/bin

    ensureDir $out/share/ghost-one/languages
    cp -r mapcfgs $out/share/ghost-one
    cp Languages/*.cfg $out/share/ghost-one/languages
    cp language.cfg $out/share/ghost-one/languages/English.cfg
    cp ip-to-country.csv $out/share/ghost-one/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.codelain.com/forum/;
    description = "A Warcraft III: Reign of Chaos and Warcraft III: The Frozen Throne game hosting bot";
    license = licenses.asl20;
    maintainers = [ maintainers.phreedom ];
  };
}