{ stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "any-nix-shell-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "haslersn";
    repo = "any-nix-shell";
    rev = "v${version}";
    sha256 = "02cv86csk1m8nlh2idvh7bjw43lpssmdawya2jhr4bam2606yzdv";
  };

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp -r bin $out
    wrapProgram $out/bin/any-nix-shell --prefix PATH ":" $out/bin
  '';

  meta = with stdenv.lib; {
    description = "fish and zsh support for nix-shell";
    license = licenses.mit;
    homepage = https://github.com/haslersn/any-nix-shell;
    maintainers = with maintainers; [ haslersn ];
  };
}