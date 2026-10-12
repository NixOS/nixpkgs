{
  fetchFromGitHub,
  stdenv,
  lib,
  fluxerHashes,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fluxer-static";

  inherit (fluxerHashes) version;

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (fluxerHashes) rev hash;
  };

  installPhase = ''
    mkdir -p $out/share/fluxer-static

    cp -r fluxer_static/* $out/share/fluxer-static
  '';

  meta = {
    description = "Static asset bundle for Fluxer, a free and open source instant messaging and VoIP chat app";
    license =
      with lib.licenses;
      AND [
        cc-by-sa-40 # fluxer assets
        cc-by-40 # Twemoji redist
        # TODO spellcheck licenses - fluxer_static/desktop/spellcheck/dictionaries/NOTICE.md
      ];
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
  };
})
