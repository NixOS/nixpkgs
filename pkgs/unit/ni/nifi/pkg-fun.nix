{ lib, stdenv, fetchurl, makeWrapper, jre8, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nifi";
  version = "1.16.3";

  src = fetchurl {
    url = "https://archive.apache.org/dist/nifi/${version}/nifi-${version}-bin.tar.gz";
    sha256 = "sha256-57ZtgK1Z8G/nX2rtf7osmymvE4RukGi7CIvCvRQNKuE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre8 ];

  installPhase = ''
    mv ../$sourceRoot $out
    rm -f $out/bin/*bat
    rm -rf $out/extensions
    mkdir -p $out/share/nifi
    mv $out/conf $out/share/nifi
    mv $out/docs $out/share/nifi
    mv $out/{LICENSE,NOTICE,README} $out/share/nifi

    substituteInPlace $out/bin/nifi.sh \
      --replace "/bin/sh" "${stdenv.shell}"
    substituteInPlace $out/bin/nifi-env.sh \
      --replace "#export JAVA_HOME=/usr/java/jdk1.8.0/" "export JAVA_HOME=${jre8}"
  '';

  passthru = {
    tests.nifi = nixosTests.nifi;
  };

  meta = with lib; {
    description = "Easy to use, powerful, and reliable system to process and distribute data";
    longDescription = ''
      Apache NiFi supports powerful and scalable directed graphs of data routing,
      transformation, and system mediation logic.
    '';
    license = licenses.asl20;
    homepage = "https://nifi.apache.org";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ izorkin ];
  };
}
