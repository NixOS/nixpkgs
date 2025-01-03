{ lib
, stdenv
, fetchpatch
, fetchurl
, unzip
, gdc
, SDL
, SDL_mixer
, bulletml
}:

let
debianPatch = patchname: hash: fetchpatch {
  name = "${patchname}.patch";
  url = "https://sources.debian.org/data/main/t/titanion/0.3.dfsg1-7/debian/patches/${patchname}";
  sha256 = hash;
};

in stdenv.mkDerivation (finalAttrs: {
  pname = "titanion";
  version = "0.3";

  src = fetchurl {
    url = "http://abagames.sakura.ne.jp/windows/ttn${lib.replaceStrings ["."] ["_"] finalAttrs.version}.zip";
    sha256 = "sha256-fR0cufi6dU898wP8KGl/vxbfQJzMmMxlYZ3QNGLajfM=";
  };

  patches = [
    (debianPatch
      "imports.patch"
      "sha256-kSXpaTpYq6w9e0yLES2QGNQ8+vFIiOpw2P9MA8gZr8s=")
    (debianPatch
      "fix.diff"
      "sha256-0WkkfuhJaAMY46VVyc3ldMQwgOVoQJDw/8zbm6H2sHU=")
    (debianPatch
      "directories.patch"
      "sha256-fhQJuy2+r0YOQNwMqG85Gr7fJehmf00Scran+NPYQrw=")
    (debianPatch
      "windowed.patch"
      "sha256-xouXIuIKfKFGsoOEJqL9jdsdnkX4nqwPGcoB+32Wvgo=")
    (debianPatch
      "dotfile.patch"
      "sha256-sAml53Hh0ltbqN8xZDZuUJcaPfjK56jf4ymFXYD38v0=")
    (debianPatch
      "window-resize.patch"
      "sha256-WwAi1aU4CmaX+O8fw0TfLhNSXFaObExrn7nuhesVkKM=")
    (debianPatch
      "makefile.patch"
      "sha256-g0jDPmc0SWXkTLhiczeTse/WGCtgMUsbyPNZzwK3U+o=")
    (debianPatch
      "dlang_v2.patch"
      "sha256-tfTAAKlPFSjbfAK1EjeB3unj9tbMlNaajJ+VVSMMiYw=")
    (debianPatch
      "gdc-8.patch"
      "sha256-BxkPfSEymq7TDA+yjJHaYsjtGr0Tuu1/sWLwRBAMga4=")
  ];

  postPatch = ''
    rm *.dll ttn.exe
    rm -r lib
    for f in src/abagames/ttn/screen.d src/abagames/util/sdl/sound.d src/abagames/util/sdl/texture.d; do
      substituteInPlace $f \
        --replace "/usr/" "$out/"
    done
  '';

  nativeBuildInputs = [
    unzip
    gdc
  ];

  buildInputs = [
    SDL
    SDL_mixer
    bulletml
  ];

  installPhase = ''
    install -Dm755 titanion $out/bin/titanion
    mkdir -p $out/share/games/titanion
    cp -r sounds images $out/share/games/titanion/
  '';

  meta = with lib; {
    homepage = "http://www.asahi-net.or.jp/~cs8k-cyu/windows/ttn_e.html";
    description = "Strike down super high-velocity swooping insects";
    mainProgram = "titanion";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
