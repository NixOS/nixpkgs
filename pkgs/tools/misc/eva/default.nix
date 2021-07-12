{ lib, fetchFromGitHub, rustPlatform, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.2.7";

  cargoSha256 = "08wm34rd03m5kd2zar23yhvi66kalzdqkgd6cqa1nq0ra4agnan7";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
    rev = "6ce0fc0212a34ffb647b24d9d903029ac4518165";
    sha256 = "10242vnq2ph0g3p2hdacs4lmx3f474xm04nadplxbpv9xh4nbag3";
  };

  cargoPatches = [ ./Cargo.lock.patch ];

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
