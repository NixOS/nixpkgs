{ lib, stdenv, fetchzip, makeWrapper, jdk11, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nifi";
  version = "1.27.0";

  src = fetchzip {
    url = "mirror://apache/nifi/${version}/nifi-${version}-bin.zip";
    hash = "sha256-D3o7MLn8vdDqzk6/AJ7Lmq6Yx2swy8CwOyDTlxFSVME=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk11 ];

  installPhase = ''
    cp -r ../$sourceRoot $out
    rm -f $out/bin/*bat
    rm -rf $out/extensions
    mkdir -p $out/share/nifi
    mv $out/conf $out/share/nifi
    mv $out/docs $out/share/nifi
    mv $out/{LICENSE,NOTICE,README} $out/share/nifi

    substituteInPlace $out/bin/nifi.sh \
      --replace "/bin/sh" "${stdenv.shell}"
    substituteInPlace $out/bin/nifi-env.sh \
      --replace "#export JAVA_HOME=/usr/java/jdk1.8.0/" "export JAVA_HOME=${jdk11}"
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
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ izorkin ];
  };
}
