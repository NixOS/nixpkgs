{ lib, symlinkJoin, nix-index-unwrapped, makeWrapper, nix }:

symlinkJoin {
  inherit (nix-index-unwrapped) name meta;

  paths = [ nix-index-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/nix-index \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';
}
