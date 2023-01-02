{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, runCommand
, rustPlatform
, openssl
, zlib
, zstd
, pkg-config
, python3
, xorg
, libiconv
, AppKit
, Foundation
, Security
# darwin.apple_sdk.sdk
, sdk
, nghttp2
, libgit2
, withExtraFeatures ? true
, testers
, nushell
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.73.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-hxcB5nzhVjsC5XYR4Pt3GN4ZEgWpetQQZr0mj3bAnRc=";
  };

  cargoSha256 = "sha256-pw+pBZeXuKSaP/qC3aiauXAH/BRR1rQZ2jVVmR1JQhU=";

  # enable pkg-config feature of zstd
  cargoPatches = [ ./zstd-pkg-config.patch ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ python3 ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [ zlib libiconv Security ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    Foundation
    (
      # Pull a header that contains a definition of proc_pid_rusage().
      # (We pick just that one because using the other headers from `sdk` is not
      # compatible with our C++ standard library. This header is already in
      # the standard library on aarch64)
      # See also:
      # https://github.com/shanesveller/nixpkgs/tree/90ed23b1b23c8ee67928937bdec7ddcd1a0050f5/pkgs/development/libraries/webkitgtk/default.nix
      # https://github.com/shanesveller/nixpkgs/blob/90ed23b1b23c8ee67928937bdec7ddcd1a0050f5/pkgs/tools/system/btop/default.nix#L32-L38
      runCommand "${pname}_headers" { } ''
        install -Dm444 "${lib.getDev sdk}"/include/libproc.h "$out"/include/libproc.h
      ''
    )
  ] ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withExtraFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  buildFeatures = lib.optional withExtraFeatures "extra";

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
    tests.version = testers.testVersion {
      package = nushell;
    };
    updateScript = nix-update-script { };
  };
}
