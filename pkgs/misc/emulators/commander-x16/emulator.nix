{ stdenv
, lib
, fetchFromGitHub
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "x16-emulator";
  version = "38";

  src = fetchFromGitHub {
    owner = "commanderx16";
    repo = pname;
    rev = "r${version}";
    sha256 = "WNRq/m97NpOBWIk6mtxBAKmkxCGWacWjXeOvIhBrkYE=";
  };

  dontConfigure = true;

  buildInputs = [ SDL2 ];

  installPhase = ''
    runHook preInstall
    install -D --mode 755 --target-directory $out/bin/ x16emu
    install -D --mode 444 --target-directory $out/share/doc/${pname} README.md
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.commanderx16.com/forum/index.php?/home/";
    description = "The official emulator of CommanderX16 8-bit computer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = SDL2.meta.platforms;
  };

  passthru = {
    # upstream project recommends emulator and rom synchronized;
    # passing through the version is useful to ensure this
    inherit version;
  };
}
