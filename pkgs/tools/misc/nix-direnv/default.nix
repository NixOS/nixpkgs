{ lib
, stdenv
, fetchFromGitHub
, gnugrep
, nix
, enableFlakes ? null # deprecated
}:
stdenv.mkDerivation rec {
  pname = "nix-direnv";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = version;
    sha256 = "sha256-vMs4CyMhEy96gWMWXD74rTR1uNjU+y21i0dh6AdaMGE=";
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
