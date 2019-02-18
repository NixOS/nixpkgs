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
  version = "unstable-2019-02-01";
  goPackagePath = "github.com/adisbladis/vgo2nix";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "adisbladis";
    repo = "vgo2nix";
    rev = "8213e1ffe9e59b1f92df15a995eafd96b66da472";
    sha256 = "1djwsw7zbprz4czaqsimpwccmmnk8wn38ksj7dis8xdvqrfy7h0g";
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
