{ stdenv
, python3
, fetchFromGitHub
, nix
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "1kafp3x95dklydy5224w0a292rd8pv30lz6z5ddk6y7zg3fsxrcr";
  };

  buildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/nix-review --prefix PATH : ${nix}/bin
  '';

  meta = with stdenv.lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = https://github.com/Mic92/nix-review;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
