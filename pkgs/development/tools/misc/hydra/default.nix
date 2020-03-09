{ hydra-unwrapped, fetchFromGitHub, nix, nixFlakes, nixUnstable }:

{
  hydra-stable = hydra-unwrapped {
    broken = true;
    flavour = "nix-stable";
    inherit nix;
    version = "2020-03-04";
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "123bee1db599818f34f880a756a44339c57c7ade";
      sha256 = "0psjhpyfa39zh4ymva27xri7xpz69cp4miafx7729jibgi28dynv";
    };
  };

  hydra-unstable = hydra-unwrapped {
    version = "2020-03-04";
    flavour = "nix-unstable";
    nix = nixUnstable;
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "123bee1db599818f34f880a756a44339c57c7ade";
      sha256 = "0psjhpyfa39zh4ymva27xri7xpz69cp4miafx7729jibgi28dynv";
    };
  };

  hydra-flakes = hydra-unwrapped {
    version = "2020-03-04";
    flavour = "nix-flakes";
    nix = nixFlakes;
    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "101a9b3797cb94d8177c997b3db5af97b0f48e6b";
      sha256 = "04p6lvd7g5k99pyrx4ya9vlrp3296mrp82rf69yfh4v62k9brck3";
    };
  };
}
