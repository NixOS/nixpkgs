{ lib
, stdenv
, fetchFromGitHub
, nixosTests
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2023-05-16";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "7be75bcf1a533272bc69684b4b7d33c2adba315c";
    hash = "sha256-WHAUrDiXy5HCwN876bZGc/OUHJITf6Fnpx4kAwAhcAs=";
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
