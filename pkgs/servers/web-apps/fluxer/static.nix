{
  fetchFromGitHub,
  stdenv,
  lib,
}:
let
  versioning = lib.importJSON ./versioning.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fluxer-static";
  inherit (versioning) version cargoHash;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
  };

  installPhase = ''
    mkdir -p $out/share/fluxer-static

    cp -r fluxer_static/* $out/share/fluxer-static
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
  };
})
