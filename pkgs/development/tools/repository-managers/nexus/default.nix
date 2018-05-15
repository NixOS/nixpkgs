{ stdenv, fetchurl, makeWrapper, jre, gawk }:

stdenv.mkDerivation rec {
  name = "nexus-${version}";
  version = "3.11.0-01";

  src = fetchurl {
    url = "https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${version}-mac.tgz";
    sha256 = "1h5nfzb1sqhzb5j7w2dpmdi7vnnc9g6zx43a44f3zjvlxh1s0vim";
  };

  sourceRoot = name;

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./nexus-bin.patch ./nexus-vm-opts.patch ];

  postPatch = ''
    substituteInPlace bin/nexus.vmoptions \
      --replace etc/karaf $out/etc/karaf \
      --replace =. =$out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv * .install4j $out
    rm -fv $out/bin/nexus.bat

    wrapProgram $out/bin/nexus \
      --set JAVA_HOME ${jre} \
      --set ALTERNATIVE_NAME "nexus" \
      --prefix PATH "${stdenv.lib.makeBinPath [ gawk ]}"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Repository manager for binary software components";
    homepage = http://www.sonatype.org/nexus;
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ aespinosa ironpinguin ma27 ];
  };
}
