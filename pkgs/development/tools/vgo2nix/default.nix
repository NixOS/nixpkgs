{ stdenv
, lib
, buildGoPackage
, go
, makeWrapper
, nix-prefetch-git
, fetchFromGitHub
}:

buildGoPackage {
  pname = "vgo2nix";
  version = "unstable-2019-02-06";
  goPackagePath = "github.com/adisbladis/vgo2nix";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "adisbladis";
    repo = "vgo2nix";
    rev = "f2694cd352830f0561bc00bbcaa08cefb2e36439";
    sha256 = "10cwi67cyhqjq1pwhry2n1v8z7wybl4cawzmjmfgs5mbsvqp0h78";
  };

  goDeps = ./deps.nix;

  allowGoReference = true;

  postInstall = with stdenv; let
    binPath = lib.makeBinPath [ nix-prefetch-git go ];
  in ''
    wrapProgram $bin/bin/vgo2nix --prefix PATH : ${binPath}
  '';

  meta = with stdenv.lib; {
    description = "Convert go.mod files to nixpkgs buildGoPackage compatible deps.nix files";
    homepage = https://github.com/adisbladis/vgo2nix;
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };

}
