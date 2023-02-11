{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2022-10-15";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "e3d5eec21da31107457f868f7f37c48c6809b7fa";
    hash = "sha256-gxcsWLIs2+28SOLLeAP7iP6MaLE445CKTlD+gVE6V5g=";
  };

  buildPhase = ''
    runHook preBuild
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C apfsck install DESTDIR="$out" $installFlags
    make -C mkapfs install DESTDIR="$out" $installFlags
    runHook postInstall
  '';

  meta = with lib; {
    description = "Experimental APFS tools for linux";
    homepage = "https://github.com/linux-apfs/apfsprogs";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
