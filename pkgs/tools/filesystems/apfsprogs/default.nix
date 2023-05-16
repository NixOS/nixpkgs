{ lib
, stdenv
, fetchFromGitHub
, nixosTests
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
<<<<<<< HEAD
  version = "unstable-2023-06-06";
=======
  version = "unstable-2023-03-21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
<<<<<<< HEAD
    rev = "91827679dfb1d6f5719fbe22fa67e89c17adb133";
    hash = "sha256-gF7bOozAGGpuVP23mnPW81qH2gnVUdT9cxukzGJ+ydI=";
=======
    rev = "be41cc38194bd41a41750631577e6d8b31953103";
    hash = "sha256-9o8DKXyK5qIoVGVKMJxsinEkbJImyuDglf534kanzFE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildPhase = ''
    runHook preBuild
<<<<<<< HEAD
    make -C apfs-snap $makeFlags
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
<<<<<<< HEAD
    make -C apfs-snap install DESTDIR="$out" $installFlags
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
