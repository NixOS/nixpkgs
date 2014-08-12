{ fetchurl, stdenv, jre, ctags, makeWrapper, coreutils, git }:

stdenv.mkDerivation rec {
  name = "opengrok-0.12.1";

  src = fetchurl {
    url = "http://java.net/projects/opengrok/downloads/download/${name}.tar.gz";
    sha256 = "0ihaqgf1z2gsjmy2q96m0s07dpnh92j3ss3myiqjdsh9957fwg79";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -a * $out/
    substituteInPlace $out/bin/OpenGrok --replace /bin/uname ${coreutils}/bin/uname
    wrapProgram $out/bin/OpenGrok \
      --prefix PATH : "${ctags}/bin:${git}/bin" \
      --set JAVA_HOME "${jre}" \
      --set OPENGROK_TOMCAT_BASE "/var/tomcat"
  '';

  meta = with stdenv.lib; {
    description = "Source code search and cross reference engine";
    homepage = http://opengrok.github.io/OpenGrok/;
    license = licenses.cddl;
    maintainers = [ maintainers.lethalman ];
  };
}
