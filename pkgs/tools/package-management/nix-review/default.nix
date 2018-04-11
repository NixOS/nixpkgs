{ stdenv
, python3
, fetchFromGitHub
, nix
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "06lj3q6405fw18fq1xg0bm52cwlwx94lx5hn4zpz3rxl5g49wiyz";
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
