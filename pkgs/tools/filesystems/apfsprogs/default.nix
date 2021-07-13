{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "apfsprogs";
  version = "unstable-2021-05-07";

  src = fetchFromGitHub {
    owner = "linux-apfs";
    repo = "apfsprogs";
    rev = "d360211a30608a907e3ee8ad4468d606c40ec2d7";
    sha256 = "sha256-SeFs/GQfIEvnxERyww+mnynjR7E02DdtBA6JsknEM+Q=";
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
