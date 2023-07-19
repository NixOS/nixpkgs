{ fetchFromGitHub, buildNpmPackage, makeDesktopItem, lib,
  electron_19,
  nodejs,
  gnat13,
  rustup,
  python311
}:
let
  nodejs' = nodejs.overrideAttrs (oldAttrs: {
    name = "nodejs-16.13.1";
    version = "16.13.1";
  });
in
buildNpmPackage rec {
  pname = "gdlauncher";
  version = "1.1.30";
  src = fetchFromGitHub {
    owner = "gorilla-devs";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-TH7k2nnpCOTEsP5Doo2EmWDH9weGrlvcBhymicPkGjs=";
  };

  nativeBuildInputs = [ gnat13 rustup nodejs' (python311.withPackages(ps: with ps; [ distutils_extra ])) ];

  forceGitDeps = true;
  makeCacheWritable = true;
  dontNpmBuild = true;
  NODE_OPTIONS = "--openssl-legacy-provider";
  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmFlags = [ "--legacy-peer-deps" "--ignore-scripts" ];
  npmDepsHash = "sha256-br1Mast/0UYW3nPC/vgkfXDqESbDfEYOwrimU8v+9W0=";
  npmBuildScript = "release";

  desktopItem = makeDesktopItem {
    name = "gdlauncher";
    exec = "gdlauncher";
    icon = "gdlauncher";
    desktopName = "GDLauncher";
    comment = meta.description;
    categories = [ "Game" ];
    mimeTypes = [ "x-scheme-handler/gdlauncher" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/gdlauncher
    cp -r src public $out/lib/node_modules/gdlauncher/

    install -Dm644 public/icon.png $out/share/icons/hicolor/256x256/apps/gdlauncher.png

    ln -s $out/lib/

    makeWrapper '${electron_19}/bin/electron' $out/bin/gdlauncher \
      --add-flags $out/lib/node_modules/gdlauncher/src

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple, yet powerful Minecraft custom launcher with a strong focus on the user experience";
    homepage = "https://gdlauncher.com/";
    changelog = "https://github.com/gorilla-devs/GDLauncher/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ PassiveLemon ];
    platforms = [ "x86_64-linux" ];
  };
}
