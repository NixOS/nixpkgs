{ lib, stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "any-nix-shell";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "haslersn";
    repo = "any-nix-shell";
    rev = "v${version}";
    sha256 = "05xixgsdfv0qk648r74nvazw16dpw49ryz8dax9kwmhqrgkjaqv6";
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp -r bin $out
    wrapProgram $out/bin/any-nix-shell --prefix PATH ":" $out/bin
  '';

  meta = with lib; {
    description = "fish and zsh support for nix-shell";
    license = licenses.mit;
    homepage = "https://github.com/haslersn/any-nix-shell";
    maintainers = with maintainers; [ haslersn ];
  };
}
