{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2021-10-26";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "05ecfa367a8142e289dc76333294271b5edfe395";
    sha256 = "sha256-McGQG8f12DTp/It8KjMHGyfE5tgmgLd7MZlZIn/xC+E=";
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
