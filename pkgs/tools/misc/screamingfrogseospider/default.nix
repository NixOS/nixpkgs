{ stdenv, lib, fetchurl, dpkg, oraclejre  }:
with stdenv.lib;
stdenv.mkDerivation rec {
  version = "12.4";
  name = "screamingfrogseospider-${version}";
  src = fetchurl {
    url = "https://download.screamingfrog.co.uk/products/seo-spider/screamingfrogseospider_${version}_all.deb";
    sha256 = "587167924f8d4914adbf0c122c190aafdafcd388353d6fca3449dcae8c148814";
  };
  buildInputs = [ dpkg ];
  unpackPhase = "dpkg -X $src .";
  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out/
    substituteInPlace $out/usr/bin/screamingfrogseospider \
        --replace '/usr/share/screamingfrogseospider/jre/' "${oraclejre}/" \
        --replace '-jar /usr/share/' "-jar $out/usr/share/" \
        --replace '-Djava.ext.dirs=' '-classpath '
    ln -s $out/usr/bin/screamingfrogseospider $out/bin/screamingfrogseospider
    rm -rf $out/usr/share/screamingfrogseospider/tmp
  '';
    meta = {
      description = "Screaming Frog SEO Spider Tool";
      homepage = https://www.screamingfrog.co.uk/;
      license = licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux"];
      maintainers = with maintainers; [ melling ];
    };
}
