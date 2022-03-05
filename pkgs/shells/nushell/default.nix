{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, zlib
, zstd
, pkg-config
, python3
, xorg
, libiconv
, AppKit
, Security
, nghttp2
, libgit2
, withExtraFeatures ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-LMG72XfDHA9dKiBbaB09v0rDdUKRy/Czu/lsYw6jUog=";
  };

  cargoSha256 = "sha256-wgaRTf+ZQ7alibCdeCjSQhhR9MC77qM1n0jakDgr114=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [ zlib libiconv Security ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withExtraFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  buildFeatures = lib.optional withExtraFeatures "extra";

  # Since 0.34, nu has an indirect dependency on `zstd-sys` (via `polars` and
  # `parquet`, for dataframe support), which by default has an impure build
  # (git submodule for the `zstd` C library). The `pkg-config` feature flag
  # fixes this, but it's hard to invoke this in the right place, because of
  # the indirect dependencies. So add a direct dependency on `zstd-sys` here
  # at the top level, along with this feature flag, to ensure that when
  # `zstd-sys` is transitively invoked, it triggers a pure build using the
  # system `zstd` library provided above.
  #
  # (If this patch needs updating, in a nushell repo add the zstd-sys line to
  # Cargo.toml, then `cargo update --package zstd-sys` to update Cargo.lock.)
  cargoPatches = [ ./use-system-zstd-lib.diff ];

  # TODO investigate why tests are broken on darwin
  # failures show that tests try to write to paths
  # outside of TMPDIR
  doCheck = ! stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne johntitor marsam ];
    mainProgram = "nu";
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
