{ stdenv, fetchurl, jre, ctags, makeWrapper, coreutils, git }:

stdenv.mkDerivation rec {
  name = "opengrok-${version}";
  version = "1.0";

  # binary distribution
  src = fetchurl {
    url = "https://github.com/oracle/opengrok/releases/download/${version}/${name}.tar.gz";
    sha256 = "0h4rwfh8m41b7ij931gcbmkihri25m48373qf6ig0714s66xwc4i";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -a * $out/
    substituteInPlace $out/bin/OpenGrok --replace "/bin/uname" "${coreutils}/bin/uname"
    substituteInPlace $out/bin/Messages --replace "#!/bin/ksh" "#!${stdenv.shell}"
    wrapProgram $out/bin/OpenGrok \
      --prefix PATH : "${stdenv.lib.makeBinPath [ ctags git ]}" \
      --set JAVA_HOME "${jre}" \
      --set OPENGROK_TOMCAT_BASE "/var/tomcat"
  '';

  meta = with stdenv.lib; {
    description = "Source code search and cross reference engine";
    homepage = https://opengrok.github.io/OpenGrok/;
    license = licenses.cddl;
    maintainers = [ maintainers.lethalman ];
  };
}
