{ lib, stdenv, fetchurl, makeWrapper, jre_headless, gawk }:

stdenv.mkDerivation rec {
  pname = "nexus";
  version = "3.30.0-01";

  src = fetchurl {
    url = "https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${version}-unix.tar.gz";
    sha256 = "sha256-axhuw1FNut+JqS1WCxyQmP08qh0tXn9UAvz2Gj1kGPs=";
  };

  preferLocalBuild = true;

  sourceRoot = "${pname}-${version}";

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
      --set JAVA_HOME ${jre_headless} \
      --set ALTERNATIVE_NAME "nexus" \
      --prefix PATH "${lib.makeBinPath [ gawk ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Repository manager for binary software components";
    homepage = "http://www.sonatype.org/nexus";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ aespinosa ironpinguin zaninime ];
  };
}
