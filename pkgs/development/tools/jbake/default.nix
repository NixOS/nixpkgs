{ stdenv, fetchzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "2.6.5";
  pname = "jbake";

  src = fetchzip {
    url = "https://dl.bintray.com/jbake/binary/${pname}-${version}-bin.zip";
    sha256 = "0ripayv1vf4f4ylxr7h9kad2xhy3y98ca8s4p38z7dn8l47zg0qw";
  };

  buildInputs = [ makeWrapper jre ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out
    cp -vr * $out
    wrapProgram $out/bin/jbake --set JAVA_HOME "${jre}"
  '';

  checkPhase = ''
    export JAVA_HOME=${jre}
    bin/jbake | grep -q "${version}" || (echo "jbake did not return correct version"; exit 1)
  '';
  doCheck = true;

  meta = with stdenv.lib; {
    description = "JBake is a Java based, open source, static site/blog generator for developers & designers";
    homepage = "https://jbake.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
