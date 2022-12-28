{ lib, stdenv, fetchurl, jdk }:

stdenv.mkDerivation rec {
  pname = "jboss-as";
  version = "7.1.1.Final";
  src = fetchurl {
    url = "https://download.jboss.org/jbossas/${lib.versions.majorMinor version}/jboss-as-${version}/jboss-as-${version}.tar.gz";
    sha256 = "1bdjw0ib9qr498vpfbg8klqw6rl11vbz7vwn6gp1r5gpqkd3zzc8";
  };

  installPhase = ''
    mv $PWD $out
    find $out/bin -name \*.sh -print0 | xargs -0 sed -i -e '/#!\/bin\/sh/aJAVA_HOME=${jdk}'
  '';

  meta = with lib; {
    homepage = "https://www.jboss.org/";
    description = "Open Source J2EE application server";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21;
    maintainers = [ maintainers.sander ];
    platforms = platforms.unix;
    knownVulnerabilities = [
      "CVE-2015-7501: remote code execution in apache-commons-collections: InvokerTransformer during deserialisation"
    ];
  };
}
