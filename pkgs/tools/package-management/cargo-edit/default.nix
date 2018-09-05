{ stdenv, lib, buildPlatform, fetchgit, fetchFromGitHub, darwin
, buildRustCrate, defaultCrateOverrides }:

((import ./Cargo.nix { inherit lib buildPlatform buildRustCrate fetchgit; }).cargo_edit {}).override {
  crateOverrides = defaultCrateOverrides // {
    cargo-edit = attrs: rec {
      name = "cargo-edit-${version}";
      version = "0.3.0";

      src = fetchFromGitHub {
        owner = "killercup";
        repo = "cargo-edit";
        rev = "v${version}";
        sha256 = "0ngxyzqy5pfc0fqbvqw7kd40jhqzp67qvpzvh3yggk9yxa1jzsp0";
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
