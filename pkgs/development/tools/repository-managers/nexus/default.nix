{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gawk }:

stdenv.mkDerivation rec {
  pname = "nexus";
<<<<<<< HEAD
  version = "3.52.0-01";

  src = fetchurl {
    url = "https://download.sonatype.com/nexus/3/nexus-${version}-unix.tar.gz";
    hash = "sha256-+Hdmuy7WBtUIjEBZyLgE3a3+L/lANHiy1VRBJ2s686U=";
=======
  version = "3.45.0-01";

  src = fetchurl {
    url = "https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${version}-unix.tar.gz";
    hash = "sha256-ISTORslFPgFt0kEKK17fpBXi3yAMwgm6qDnk33V2wa0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preferLocalBuild = true;

  sourceRoot = "${pname}-${version}";

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./nexus-bin.patch ./nexus-vm-opts.patch ];

  postPatch = ''
    substituteInPlace bin/nexus.vmoptions \
<<<<<<< HEAD
      --replace ../sonatype-work /var/lib/sonatype-work \
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    homepage = "https://www.sonatype.com/products/sonatype-nexus-oss";
=======
    homepage = "http://www.sonatype.org/nexus";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ aespinosa ironpinguin zaninime ];
  };
}
