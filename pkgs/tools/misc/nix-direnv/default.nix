{ lib
, stdenv
, fetchFromGitHub
, gnugrep
, nixStable
, nixUnstable
, enableFlakes ? false
}:

let
  nix = if enableFlakes then nixUnstable else nixStable;
in
stdenv.mkDerivation rec {
  pname = "nix-direnv";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = version;
    sha256 = "sha256-PEteip6FcaJ2wqdhSM9SqL7bJ4nimcOrC3s2pWunEIE=";
  };

  # Substitute instead of wrapping because the resulting file is
  # getting sourced, not executed:
  postPatch = ''
    sed -i "1a NIX_BIN_PREFIX=${nix}/bin/" direnvrc
    substituteInPlace direnvrc --replace "grep" "${gnugrep}/bin/grep"
  '';

  installPhase = ''
    runHook preInstall
    install -m500 -D direnvrc $out/share/nix-direnv/direnvrc
    runHook postInstall
  '';

  meta = with lib; {
    description = "A fast, persistent use_nix implementation for direnv";
    homepage    = "https://github.com/nix-community/nix-direnv";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ mic92 ];
  };
}
