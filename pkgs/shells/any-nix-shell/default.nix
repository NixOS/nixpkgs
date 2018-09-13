{ stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation rec {
  name = "any-nix-shell-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "haslersn";
    repo = "any-nix-shell";
    rev = "v${version}";
    sha256 = "1fb4c2xkvk3hwy6km02h7j6wsmpachi66n286p2grzgk5k88pijr";
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