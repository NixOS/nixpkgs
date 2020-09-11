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
  version = "unstable-2020-05-05";
  goPackagePath = "github.com/adisbladis/vgo2nix";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "vgo2nix";
    rev = "71e59bf268d5257a0f89b2f59cd20fd468c8c6ac";
    sha256 = "1pcdkknq2v7nrs0siqcvvq2x0qqz5snwdz2lpjnad8i33rwhmayh";
  };

  goDeps = ./deps.nix;

  allowGoReference = true;

  postInstall = with stdenv; let
    binPath = lib.makeBinPath [ nix-prefetch-git go ];
  in ''
    wrapProgram $out/bin/vgo2nix --prefix PATH : ${binPath}
  '';

  meta = with stdenv.lib; {
    description = "Convert go.mod files to nixpkgs buildGoPackage compatible deps.nix files";
    homepage = "https://github.com/nix-community/vgo2nix";
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };

}
