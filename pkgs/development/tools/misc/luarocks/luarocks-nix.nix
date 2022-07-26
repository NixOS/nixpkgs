{ luarocks, fetchFromGitHub, nix-update-script }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "luarocks-nix";
    rev = "b1ff9eeb64c7c1dc5fc177008d6f2be9191c6aa2";
    sha256 = "sha256-mkzrf/6yMyLMIEDwsuCIxi1HJvg57ybyZPXVheFAAHE=";
  };
  patches = [];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "luarocks-nix";
    };
  };

  meta.mainProgram = "luarocks";
})
