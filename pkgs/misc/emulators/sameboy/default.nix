{ lib, stdenv, fetchFromGitHub, gtk3, rgbds, SDL2, wrapGAppsHook, glib }:

stdenv.mkDerivation rec {
  pname = "sameboy";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "LIJI32";
    repo = "SameBoy";
    rev = "v${version}";
    sha256 = "0h42cixbf0m2qiwrqzygh0x166h9ikxa5dzi3jbqld2dygk932n7";
  };

  enableParallelBuilding = true;
  # glib and wrapGAppsHook are needed to make the Open ROM menu work.
  nativeBuildInputs = [ rgbds glib wrapGAppsHook ];
  buildInputs = [ SDL2 ];

  makeFlags = [
    "CONF=release"
    "FREEDESKTOP=true"
    "PREFIX=$(out)"
  ];

  postPatch = ''
    substituteInPlace OpenDialog/gtk.c \
      --replace '"libgtk-3.so"' '"${gtk3}/lib/libgtk-3.so"'
  '';

  meta = with lib; {
    homepage = "https://sameboy.github.io";
    description = "Game Boy, Game Boy Color, and Super Game Boy emulator";

    longDescription = ''
      SameBoy is a user friendly Game Boy, Game Boy Color and Super
      Game Boy emulator for macOS, Windows and Unix-like platforms.
      SameBoy is extremely accurate and includes a wide range of
      powerful debugging features, making it ideal for both casual
      players and developers. In addition to accuracy and developer
      capabilities, SameBoy has all the features one would expect from
      an emulator – from save states to scaling filters.
    '';

    license = licenses.mit;
    maintainers = with maintainers; [ NieDzejkob ];
    platforms = platforms.linux;
  };
}
