{ lib, symlinkJoin, nix-index-unwrapped, makeWrapper, nix }:

if nix == null then nix-index-unwrapped else
symlinkJoin {
  inherit (nix-index-unwrapped) name;

  paths = [ nix-index-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/nix-index \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = nix-index-unwrapped.meta // {
    hydraPlatforms = [];
  };
}
