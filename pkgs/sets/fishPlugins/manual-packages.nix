self: super: {
  ai = self.callPackage ./non-by-name/ai.nix { };

  async-prompt = self.callPackage ./non-by-name/async-prompt.nix { };

  autopair = self.callPackage ./non-by-name/autopair.nix { };

  aws = self.callPackage ./non-by-name/aws.nix { };

  bang-bang = self.callPackage ./non-by-name/bang-bang.nix { };

  bobthefish = self.callPackage ./non-by-name/bobthefish.nix { };

  bobthefisher = self.callPackage ./non-by-name/bobthefisher.nix { };

  colored-man-pages = self.callPackage ./non-by-name/colored-man-pages.nix { };

  clownfish = self.callPackage ./non-by-name/clownfish.nix { };

  bass = self.callPackage ./non-by-name/bass.nix { };

  done = self.callPackage ./non-by-name/done.nix { };

  exercism-cli-fish-wrapper = self.callPackage ./non-by-name/exercism-cli-fish-wrapper.nix { };

  fifc = self.callPackage ./non-by-name/fifc.nix { };

  fishbang = self.callPackage ./non-by-name/fishbang.nix { };

  fish-bd = self.callPackage ./non-by-name/fish-bd.nix { };

  # Fishtape 2.x and 3.x aren't compatible,
  # but both versions are used in the tests of different other plugins.
  fishtape = self.callPackage ./non-by-name/fishtape.nix { };
  fishtape_3 = self.callPackage ./non-by-name/fishtape_3.nix { };

  fish-you-should-use = self.callPackage ./non-by-name/fish-you-should-use.nix { };

  foreign-env = self.callPackage ./non-by-name/foreign-env { };

  forgit = self.callPackage ./non-by-name/forgit.nix { };

  fzf = self.callPackage ./non-by-name/fzf.nix { };

  fzf-fish = self.callPackage ./non-by-name/fzf-fish.nix { };

  github-copilot-cli-fish = self.callPackage ./non-by-name/github-copilot-cli-fish.nix { };

  git-abbr = self.callPackage ./non-by-name/git-abbr.nix { };

  grc = self.callPackage ./non-by-name/grc.nix { };

  gruvbox = self.callPackage ./non-by-name/gruvbox.nix { };

  humantime-fish = self.callPackage ./non-by-name/humantime-fish.nix { };

  hydro = self.callPackage ./non-by-name/hydro.nix { };

  macos = self.callPackage ./non-by-name/macos.nix { };

  nvm = self.callPackage ./non-by-name/nvm.nix { };

  pisces = self.callPackage ./non-by-name/pisces.nix { };

  plugin-git = self.callPackage ./non-by-name/plugin-git.nix { };

  plugin-sudope = self.callPackage ./non-by-name/plugin-sudope.nix { };

  puffer = self.callPackage ./non-by-name/puffer.nix { };

  pure = self.callPackage ./non-by-name/pure.nix { };

  sdkman-for-fish = self.callPackage ./non-by-name/sdkman-for-fish.nix { };

  spark = self.callPackage ./non-by-name/spark.nix { };

  sponge = self.callPackage ./non-by-name/sponge.nix { };

  tide = self.callPackage ./non-by-name/tide.nix { };

  transient-fish = self.callPackage ./non-by-name/transient-fish.nix { };

  wakatime-fish = self.callPackage ./non-by-name/wakatime-fish.nix { };

  z = self.callPackage ./non-by-name/z.nix { };
}
