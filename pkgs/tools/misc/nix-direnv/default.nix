{ lib, stdenv, fetchFromGitHub, gnugrep, nix }:

stdenv.mkDerivation rec {
  pname = "nix-direnv";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = "${version}";
    sha256 = "1lwmg6mn3lf7s0345v53zadxn9v0x8z6pcbj90v5dx3pgrq41gs8";
  };

  # Substitute instead of wrapping because the resulting file is
  # getting sourced, not executed:
  postPatch = ''
    substituteInPlace direnvrc \
      --replace "grep" "${gnugrep}/bin/grep" \
      --replace "nix-shell" "${nix}/bin/nix-shell" \
      --replace "nix-instantiate" "${nix}/bin/nix-instantiate"
  '';

  installPhase = ''
    runHook preInstall
    install -m500 -D direnvrc $out/share/nix-direnv/direnvrc
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A fast, persistent use_nix implementation for direnv";
    homepage    = "https://github.com/nix-community/nix-direnv";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ mic92 ];
  };
}
