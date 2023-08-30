{ lib, stdenv, rustPlatform, fetchFromGitHub, boost, nix, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "nix-doc";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "lf-";
    repo = "nix-doc";
    sha256 = "sha256-1y4BSdKgsV4WLcaNICVh5rac1ZAtZxFM3BlhL2g/AcI=";
  };

  doCheck = true;
  buildInputs = [ boost nix ];

  nativeBuildInputs = [ pkg-config nix ];

  # Packaging support for making the nix-doc plugin load cleanly as a no-op on
  # the wrong Nix version (disabling bindnow permits loading libraries
  # requiring unavailable symbols if they are unreached)
  hardeningDisable = [ "bindnow" ];
  # Due to a Rust bug, setting -Z relro-level to anything including "off" on
  # macOS will cause link errors
  env = lib.optionalAttrs stdenv.isLinux {
    # nix-doc does not use nightly features, however, there is no other way to
    # set relro-level
    RUSTC_BOOTSTRAP = 1;
    RUSTFLAGS = "-Z relro-level=partial";
  };

  cargoSha256 = "sha256-nP03WnXBcwazAi6nVe17CpDSeUxmG84BFFMA5ueey3M=";

  meta = with lib; {
    description = "An interactive Nix documentation tool";
    longDescription = "An interactive Nix documentation tool providing a CLI for function search, a Nix plugin for docs in the REPL, and a ctags implementation for Nix script";
    homepage = "https://github.com/lf-/nix-doc";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.lf- ];
    platforms = platforms.unix;
  };
}
