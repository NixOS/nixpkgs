{ stdenv, fetchurl, makeWrapper, jre_headless, gawk }:

stdenv.mkDerivation rec {
  pname = "nexus";
  version = "3.29.0-02";

  src = fetchurl {
    url = "https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${version}-unix.tar.gz";
    sha256 = "0yxk3yy9vllxc9v4dn3fs8hh389lrw2g8gg24rx1w8bg05rrrr8z";
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
      --prefix PATH "${stdenv.lib.makeBinPath [ gawk ]}"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Repository manager for binary software components";
    homepage = "http://www.sonatype.org/nexus";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ aespinosa ironpinguin zaninime ];
  };
}
