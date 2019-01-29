{ stdenv
, lib
, buildGoPackage
, go
, makeWrapper
, nix-prefetch-git
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "vgo2nix-${version}";
  version = "unstable-2018-12-02";
  goPackagePath = "github.com/adisbladis/vgo2nix";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "adisbladis";
    repo = "vgo2nix";
    rev = "b298f4fb799fc532488fc887e1938668d7f3d219";
    sha256 = "0gr5vfz5wzpcyxsz948aniyfbryg53agvzbkhdnb5hiwhi7nay9p";
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
