{ stdenv, fetchurl, makeWrapper, jre }:
stdenv.mkDerivation rec {
  name = "nexus-${version}";
  version = "2.12.0-01";

  src = fetchurl {
    url = "https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-${version}-bundle.tar.gz";
    sha256 = "1k3z7kwcmr1pxaxfnak99fq5s8br9zbqbfpyw1afi86ykkph4g5z";
  };

  sourceRoot = name;

  buildInputs = [ makeWrapper ];

  installPhase = 
    ''
      mkdir -p $out
      cp -rfv * $out
      rm -fv $out/bin/nexus.bat
    '';

  meta = with stdenv.lib; {
    description = "Repository manager for binary software components";
    homepage = http://www.sonatype.org/nexus;
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = [ maintainers.aespinosa ];
  };
}
