{ stdenv
, lib
, fetchFromGitHub
, cc65
}:

stdenv.mkDerivation rec {
  pname = "x16-rom";
  version = "38";

  src = fetchFromGitHub {
    owner = "commanderx16";
    repo = pname;
    rev = "r${version}";
    sha256 = "xaqF0ppB7I7ST8Uh3jPbC14uRAb/WH21tHlNeTvYpoI=";
  };

  nativeBuildInputs = [ cc65 ];

  postPatch = ''
    patchShebangs scripts/
  '';

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    install -D --mode 444 --target-directory $out/share/${pname} build/x16/rom.bin
    install -D --mode 444 --target-directory $out/share/doc/${pname} README.md
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.commanderx16.com/forum/index.php?/home/";
    description = "ROM file for CommanderX16 8-bit computer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = cc65.meta.platforms;
  };

  passthru = {
    # upstream project recommends emulator and rom synchronized;
    # passing through the version is useful to ensure this
    inherit version;
  };
}
