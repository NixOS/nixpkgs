{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2022-02-23";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "5bce5c7f42843dfbbed90767640e748062e23dd2";
    sha256 = "sha256-0N+aC5paP6ZoXUD7A9lLnF2onbOJU+dqZ8oKs+dCUcg=";
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
