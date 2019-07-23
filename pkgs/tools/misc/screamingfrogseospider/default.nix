{ stdenv, lib, fetchurl, dpkg, oraclejre }:
with lib;
let
  version = "11.3";
  url = "https://download.screamingfrog.co.uk/products/seo-spider/screamingfrogseospider_${version}_all.deb";
  sha256 = "a6a7b9434dadcd0ca5d486df16386ce317ed7d4d2f7acc2730156e13859368f9";
in stdenv.mkDerivation rec {
  inherit version;
  name = "screamingfrogseospider-${version}";
  src = fetchurl {
    inherit sha256 url;
  };
  buildInputs = [ dpkg ];
  unpackPhase = "dpkg -X $src .";
  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out/
    sed -i 's|/usr/share/screamingfrogseospider/jre/|${oraclejre}/|' $out/usr/bin/screamingfrogseospider
    sed -i "s|-jar /usr/share/screamingfrogseospider/ScreamingFrogSEOSpider.jar|-jar $out/usr/share/screamingfrogseospider/ScreamingFrogSEOSpider.jar|" $out/usr/bin/screamingfrogseospider
    sed -i 's/-Djava.ext.dirs=/-classpath /' $out/usr/bin/screamingfrogseospider
    ln -s $out/usr/bin/screamingfrogseospider $out/bin/screamingfrogseospider
    rm -rf $out/usr/share/screamingfrogseospider/tmp
  '';
    meta = with lib; {
      description = "Screaming Frog SEO Spider Tool";
      homepage = https://www.screamingfrog.co.uk/;
      license = licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux"];
      maintainers = with maintainers; [ melling ];
    };
}
