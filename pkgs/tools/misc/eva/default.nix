{ lib, rustPlatform, fetchCrate, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.2.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-4rmFvu6G4h8Pl592NlldSCkqZBbnTcXrs98ljIJmTXo=";
  };

  cargoSha256 = "sha256-BG/W8lG/47kyA7assS6efEO+DRkpSFcZQhlSIozlonA=";

  patches = [
    # to fix the test suite (can be removed as soon as #33 is merged).
    (fetchpatch {
      url = "https://github.com/NerdyPepper/eva/commit/cacf51dbb9748b1dbe97b35f3c593a0a272bd4db.patch";
      sha256 = "11q7dkz2x1888f3awnlr1nbbxzzfjrr46kd0kk6sgjdkyfh50cvv";
    })

    # to fix `cargo test -- --test-threads $NIX_BUILD_CORES`
    (fetchpatch {
      url = "https://github.com/NerdyPepper/eva/commit/ccfb3d327567dbaf03b2283c7e684477e2e84590.patch";
      sha256 = "003yxqlyi8jna0rf05q2a006r2pkz6pcwwfl3dv8zb6p83kk1kgj";
    })
  ];

  meta = with lib; {
    description = "A calculator REPL, similar to bc";
    homepage = "https://github.com/NerdyPepper/eva";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ma27 ];
  };
}
