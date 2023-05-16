{ lib, stdenv, fetchurl, unzip, nixosTests }:

stdenv.mkDerivation rec {
  pname = "grocy";
<<<<<<< HEAD
  version = "4.0.3";

  src = fetchurl {
    url = "https://github.com/grocy/grocy/releases/download/v${version}/grocy_${version}.zip";
    hash = "sha256-KBTsi634SolgA01eRthMuWx7DIF7rhvJSPxiHyuKSR8=";
=======
  version = "3.3.2";

  src = fetchurl {
    url = "https://github.com/grocy/grocy/releases/download/v${version}/grocy_${version}.zip";
    sha256 = "sha256-KF4zxrC8rlRUaBKc4iLIt6TSAHMJ+tOWptMsVcixVWs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    unzip ${src} -d .
  '';

  # NOTE: if patches are created from a git checkout, those should be modified
  # with `unixdos` to make sure those apply here.
  patches = [
    ./0001-Define-configs-with-env-vars.patch
    ./0002-Remove-check-for-config-file-as-it-s-stored-in-etc-g.patch
  ];
  patchFlags = [ "--binary" "-p1" ];

  dontBuild = true;

  passthru.tests = { inherit (nixosTests) grocy; };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = with lib; {
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ n0emis ];
=======
    maintainers = with maintainers; [ ma27 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home";
    homepage = "https://grocy.info/";
  };
}
