{ lib, stdenv, fetchzip, makeWrapper, jdk11, nixosTests }:

stdenv.mkDerivation rec {
  pname = "nifi";
<<<<<<< HEAD
  version = "1.23.2";

  src = fetchzip {
    url = "mirror://apache/nifi/${version}/nifi-${version}-bin.zip";
    hash = "sha256-NRX0lEE5/HsYnZXtLDlPUpgWMsg/2Z3cRUnJwKDGxfw=";
=======
  version = "1.21.0";

  src = fetchzip {
    url = "mirror://apache/nifi/${version}/nifi-${version}-bin.zip";
    sha256 = "sha256-AnDvZ9SV+VFdsP6KoqZIPNinAe2erT/IBY4c6i+2iTQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk11 ];

  installPhase = ''
<<<<<<< HEAD
    cp -r ../$sourceRoot $out
=======
    mv ../$sourceRoot $out
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ izorkin ];
  };
}
