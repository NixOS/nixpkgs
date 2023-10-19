{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gawk }:

stdenv.mkDerivation rec {
  pname = "nexus";
  version = "3.52.0-01";

  src = fetchurl {
    url = "https://download.sonatype.com/nexus/3/nexus-${version}-unix.tar.gz";
    hash = "sha256-+Hdmuy7WBtUIjEBZyLgE3a3+L/lANHiy1VRBJ2s686U=";
  };

  preferLocalBuild = true;

  sourceRoot = "${pname}-${version}";

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./nexus-bin.patch ./nexus-vm-opts.patch ];

  postPatch = ''
    substituteInPlace bin/nexus.vmoptions \
      --replace ../sonatype-work /var/lib/sonatype-work \
      --replace etc/karaf $out/etc/karaf \
      --replace =. =$out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv * .install4j $out
    rm -fv $out/bin/nexus.bat

    wrapProgram $out/bin/nexus \
      --set JAVA_HOME ${jre_headless} \
      --set ALTERNATIVE_NAME "nexus" \
      --prefix PATH "${lib.makeBinPath [ gawk ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Repository manager for binary software components";
    homepage = "https://www.sonatype.com/products/sonatype-nexus-oss";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ aespinosa ironpinguin zaninime ];
  };
}
