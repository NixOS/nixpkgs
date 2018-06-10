{ stdenv, pkgs, darwin, defaultCrateOverrides, fetchFromGitHub }:

((import ./cargo-edit.nix { inherit pkgs; }).cargo_edit {}).override {
  crateOverrides = defaultCrateOverrides // {
    cargo-edit = attrs: rec {
      name = "cargo-edit-${version}";
      version = "0.2.0";

      src = fetchFromGitHub {
        owner = "killercup";
        repo = "cargo-edit";
        rev = "v${version}";
        sha256 = "1jxppbb7s50pwg24qxf79fqvm1clwm2zdnv0xlkay7y05nd5bc0c";
      };

      propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

      meta = with stdenv.lib; {
        description = "A utility for managing cargo dependencies from the command line";
        homepage = https://github.com/killercup/cargo-edit;
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ gerschtli jb55 ];
        platforms = platforms.all;
      };
    };
  };
}
