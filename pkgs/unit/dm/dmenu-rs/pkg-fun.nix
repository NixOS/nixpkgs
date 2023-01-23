{ stdenv
, rustPlatform
, lib
, fetchFromGitHub
, cargo
, expat
, fontconfig
, libXft
, libXinerama
, m4
, pkg-config
, python3
}:

# The dmenu-rs package has extensive plugin support. However, this derivation
# only builds the package with the default set of plugins. If you'd like to
# further customize dmenu-rs you can build it from the source.
# See: https://github.com/Shizcow/dmenu-rs#plugins
stdenv.mkDerivation rec {
  pname = "dmenu-rs";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "Shizcow";
    repo = pname;
    rev = version;
    sha256 = "sha256-WpDqBjIZ5ESnoRtWZmvm+gNTLKqxL4IibRVCj0yRIFM=";
  };

  nativeBuildInputs = [
    cargo
    m4
    pkg-config
    python3
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    expat
    fontconfig
    libXft
    libXinerama
  ];

  # The dmenu-rs repository does not include a Cargo.lock because of its
  # dynamic build and plugin support. Generating it with make and checking it
  # in to nixpkgs here was the easiest way to supply it to rustPlatform.
  # See: https://github.com/Shizcow/dmenu-rs/issues/34#issuecomment-757415584
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  # The rust-xcb dependency dynamically generates rust code at build time.
  # This derivation uses nixpkgs rust functions that vendor each cargo
  # dependency's source code into the READ-ONLY nix store. To avoid the code
  # generation step failing, we copy the rust-xcb source out of the nix store
  # and make it writeable. Also, we remove the build's hardcoded c compiler.
  # See: https://github.com/rust-x-bindings/rust-xcb/tree/v0.8.2
  postPatch = ''
    substituteInPlace config.mk --replace "clang" ""

    chmod +w "$NIX_BUILD_TOP/cargo-vendor-dir"
    mkdir -p "$NIX_BUILD_TOP/cargo-vendor-dir/xcb-0.8.2-readwrite"
    cp -r --no-preserve=mod "$NIX_BUILD_TOP/cargo-vendor-dir/xcb-0.8.2/." "$NIX_BUILD_TOP/cargo-vendor-dir/xcb-0.8.2-readwrite"
    unlink "$NIX_BUILD_TOP/cargo-vendor-dir/xcb-0.8.2"
    mv "$NIX_BUILD_TOP/cargo-vendor-dir/xcb-0.8.2-readwrite" "$NIX_BUILD_TOP/cargo-vendor-dir/xcb-0.8.2"

    cp ${./Cargo.lock} src/Cargo.lock
  '';

  cargoRoot = "src";

  installFlags = [ "PREFIX=$(out)" ];

  # Running make test requires an X11 server. It also runs dmenu, which then
  # hangs on user input. It was too hard to figure out how to run these tests
  # deterministically. See the original PR for some discussion on this.
  doCheck = false;

  meta = with lib; {
    description = "A pixel perfect port of dmenu, rewritten in Rust with extensive plugin support";
    homepage = "https://github.com/Shizcow/dmenu-rs";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ benjaminedwardwebb ];
    platforms = platforms.linux;
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
