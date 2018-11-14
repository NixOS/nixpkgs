{ stdenv, callPackage, defaultCrateOverrides, fetchFromGitHub, cmake, curl, libssh2, libgit2, openssl, zlib }:

((callPackage ./cargo-update.nix {}).cargo_update {}).override {
  crateOverrides = defaultCrateOverrides // {
    cargo-update = attrs: rec {
      name = "cargo-update-${version}";
      version = "1.5.2";

      src = fetchFromGitHub {
        owner = "nabijaczleweli";
        repo = "cargo-update";
        rev = "v${version}";
        sha256 = "1bvrdgcw2akzd78wgvsisvghi8pvdk3szyg9s46qxv4km9sf88s7";
      };

      nativeBuildInputs = [ cmake ];
      buildInputs = [ libssh2 libgit2 openssl zlib ]
        ++ stdenv.lib.optional stdenv.isDarwin curl;

      meta = with stdenv.lib; {
        description = "A cargo subcommand for checking and applying updates to installed executables";
        homepage = https://github.com/nabijaczleweli/cargo-update;
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ gerschtli ];
        platforms = platforms.all;
      };
    };
  };
}
