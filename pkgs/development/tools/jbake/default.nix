{ stdenv, fetchzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "2.6.4";
  name = "jbake-${version}";

  src = fetchzip {
    url = "https://dl.bintray.com/jbake/binary/${name}-bin.zip";
    sha256 = "0zgp0wwxxmi13v5q5jvr610igx2vxg0bwck9j1imnn9ciakg1aaw";
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
