{ lib
, fetchFromGitHub
, buildNpmPackage
, stdenv
, nodejs
, ffmpeg
}:

let

  pname = "audiobookshelf";
  version = "2.2.11";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZDFOrDyzkGLDODfQJWO7nljrMFbq2pyDkCEN443A8m0=";
  };

  client = buildNpmPackage rec {
    inherit src version;
    pname = "audiobookshelf-client";

    sourceRoot = "source/client";

    NODE_OPTIONS = "--openssl-legacy-provider";
    npmDepsHash = "sha256-IUTV0sWyMscN4CqaEprAARI/R1eYyQ0G6BrzNuzGojw=";

    npmBuildScript = "generate";
    installPhase = ''
      mkdir -p $out/share
      mv dist $out/share/audiobookshelf-client
    '';
  };
in
buildNpmPackage {
  inherit src version pname;

  npmDepsHash = "sha256-42qG/OLoPmKrRL44POoLtk5kzVQX2ZXmEfSOaUHL4lw=";

  npmInstallFlags = "--only-production";

  buildPhase = ''
    mkdir -p "$out/bin" "$out/lib/audiobookshelf/client/dist"
    cp prod.js "$out/lib/audiobookshelf"
    cp package* "$out/lib/audiobookshelf"
    cp -r server "$out/lib/audiobookshelf"
    cp -r node_modules "$out/lib/audiobookshelf"
    cp -r ${client}/share/audiobookshelf-client/*  "$out/lib/audiobookshelf/client/dist"
  '';

  installPhase = ''
    runHook preInstall

    makeWrapper ${nodejs}/bin/node "$out/bin/audiobookshelf" --add-flags "$out/lib/audiobookshelf/prod.js" \
      --prefix PATH : ${ lib.makeBinPath [ffmpeg]} \
      --prefix SOURCE : "nixos"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Self-hosted audiobook and podcast server";
    homepage = "https://github.com/advplyr/audiobookshelf";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
