{ stdenv, fetchurl, makeWrapper, jre, gawk }:
stdenv.mkDerivation rec {
  name = "nexus-${version}";
  version = "3.5.1-02";

  src = fetchurl {
    url = "https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${version}-mac.tgz";
    sha256 = "5ef3512c2bbdd45ef35921c1a0ba109b45bd9dad88311750196aa689262258b6";
  };

  sourceRoot = name;

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./nexus-bin.patch ];

  postPatch = ''
    substituteInPlace bin/nexus.vmoptions \
      --replace ../sonatype-work/nexus3 /run/sonatype-work/nexus3 \
      --replace etc/karaf $out/etc/karaf \
      --replace =. =$out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv * .install4j $out
    rm -fv $out/bin/nexus.bat

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/nexus \
      --set JAVA_HOME ${jre} \
      --set ALTERNATIVE_NAME "nexus" \
      --prefix PATH "${stdenv.lib.makeBinPath [ gawk ]}"
  '';

  meta = with stdenv.lib; {
    description = "Repository manager for binary software components";
    homepage = http://www.sonatype.org/nexus;
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ aespinosa ironpinguin ];
  };
}
