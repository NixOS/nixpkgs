{ lib
, stdenv
, fetchFromGitHub
, nix
}:
stdenv.mkDerivation (finalAttrs:{
  pname = "nix-direnv";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = finalAttrs.version;
    hash = "sha256-rMQ+Nb6WqXm66g2TpF8E0Io9WBR0ve06MW8I759gl2M=";
  };

  # Substitute instead of wrapping because the resulting file is
  # getting sourced, not executed:
  postPatch = ''
    sed -i "1a NIX_BIN_PREFIX=${nix}/bin/" direnvrc
  '';

  installPhase = ''
    runHook preInstall
    install -m500 -D direnvrc $out/share/nix-direnv/direnvrc
    runHook postInstall
  '';

  meta = {
    description = "A fast, persistent use_nix implementation for direnv";
    homepage    = "https://github.com/nix-community/nix-direnv";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mic92 bbenne10 ];
  };
})
