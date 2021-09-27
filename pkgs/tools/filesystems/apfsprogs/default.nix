{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2021-08-24";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "5efac5a701bcb56e23cfc182b5b3901bff27d343";
    sha256 = "sha256-vQE586HwrPkF0uaTKrJ7yXb24ntRI0QmBla7N2ErAU8=";
  };

  buildPhase = ''
    runHook preBuild
    make -C apfsck $makeFlags
    make -C mkapfs $makeFlags
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C apfsck install BINDIR="$out/bin" MANDIR="$out/share/man8" $installFlags
    make -C mkapfs install BINDIR="$out/bin" MANDIR="$out/share/man8" $installFlags
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
