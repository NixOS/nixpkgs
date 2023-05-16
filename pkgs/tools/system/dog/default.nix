{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "dog";
  version = "1.7";

  src = fetchurl {
    url = "http://archive.debian.org/debian/pool/main/d/dog/dog_${version}.orig.tar.gz";
    sha256 = "3ef25907ec5d1dfb0df94c9388c020b593fbe162d7aaa9bd08f35d2a125af056";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace Makefile \
      --replace "gcc" "$CC"
  '';

  installPhase = ''
    runHook preInstall
=======
  patchPhase = ''
    substituteInPlace Makefile \
      --replace "gcc" "cc"
  '';

  installPhase = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    cp dog.1 $out/man/man1
    cp dog $out/bin
<<<<<<< HEAD
    runHook postInstall
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage = "https://lwn.net/Articles/421072/";
    description = "cat replacement";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qknight ];
    platforms = platforms.all;
  };
}
