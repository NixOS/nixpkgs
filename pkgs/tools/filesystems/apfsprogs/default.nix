{ lib
, stdenv
, fetchFromGitHub
, nixosTests
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2023-06-06";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "91827679dfb1d6f5719fbe22fa67e89c17adb133";
    hash = "sha256-gF7bOozAGGpuVP23mnPW81qH2gnVUdT9cxukzGJ+ydI=";
  };

  buildPhase = ''
    runHook preBuild
    make -C apfs-snap $makeFlags
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C apfs-snap install DESTDIR="$out" $installFlags
    make -C apfsck install DESTDIR="$out" $installFlags
    make -C mkapfs install DESTDIR="$out" $installFlags
    runHook postInstall
  '';

  passthru.tests = {
    apfs = nixosTests.apfs;
  };

  meta = with lib; {
    description = "Experimental APFS tools for linux";
    homepage = "https://github.com/linux-apfs/apfsprogs";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
