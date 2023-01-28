{ lib, stdenv, fetchzip, makeWrapper, jre }:

stdenv.mkDerivation rec {
  version = "2.6.7";
  pname = "jbake";

  src = fetchzip {
    url = "https://github.com/jbake-org/jbake/releases/download/v${version}/jbake-${version}-bin.zip";
    sha256 = "sha256-kikGnFsParq8g0dzzYtMr2vIJD2ie8PeF6TG2G5K7KE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

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

  meta = with lib; {
    description = "Java based, open source, static site/blog generator for developers & designers";
    homepage = "https://jbake.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
