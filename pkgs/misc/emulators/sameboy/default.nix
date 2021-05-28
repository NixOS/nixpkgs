{ stdenv, fetchFromGitHub, gtk3, rgbds, SDL2, wrapGAppsHook, glib }:

stdenv.mkDerivation rec {
  pname = "sameboy";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "LIJI32";
    repo = "SameBoy";
    rev = "v${version}";
    sha256 = "04w8lybi7ssnax37ka4qw7pmcm7cgnmk90p9m73zbyp5chgpqqzc";
  };

  enableParallelBuilding = true;
  # glib and wrapGAppsHook are needed to make the Open ROM menu work.
  nativeBuildInputs = [ rgbds glib wrapGAppsHook ];
  buildInputs = [ SDL2 ];

  makeFlags = "CONF=release DATA_DIR=$(out)/share/sameboy/";

  patchPhase = ''
    sed 's/-Werror //g' -i Makefile
    sed 's@"libgtk-3.so"@"${gtk3}/lib/libgtk-3.so"@g' -i OpenDialog/gtk.c
  '';

  installPhase = ''
    pushd build/bin/SDL
    install -Dm755 sameboy $out/bin/sameboy
    rm sameboy
    mkdir -p $out/share/sameboy
    cp -r * $out/share/sameboy
    popd
  '';

  meta = with stdenv.lib; {
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
