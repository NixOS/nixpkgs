{ lib, stdenv, fetchzip, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "asciidoctorj";
  version = "2.4.2";

  src = fetchzip {
    url = "http://dl.bintray.com/asciidoctor/maven/org/asciidoctor/${pname}/${version}/${pname}-${version}-bin.zip";
    sha256 = "1b4ivyzpg9p3idk48nfvgpz18qlxyycswkaab31j3dp1mniwvjla";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/asciidoctorj.bat
    cp -r . $out
    wrapProgram $out/bin/asciidoctorj \
      --prefix JAVA_HOME : ${jdk}
  '';

  meta = with lib; {
    description = "Official library for running Asciidoctor on the JVM";
    longDescription = ''
      AsciidoctorJ is the official library for running Asciidoctor on the JVM.
      Using AsciidoctorJ, you can convert AsciiDoc content or analyze the
      structure of a parsed AsciiDoc document from Java and other JVM
      languages.
    '';
    homepage = "https://asciidoctor.org/docs/asciidoctorj/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
