{ lib
, targetPlatform
, fetchFromGitHub
, rustPlatform
, cmake
, makeWrapper
, pkg-config
, removeReferencesTo
, coreutils
, findutils
, gawk
, wireguard-tools
, bash
, libsodium
}:

let
  rpBinPath = lib.makeBinPath [
    coreutils
    findutils
    gawk
    wireguard-tools
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "rosenpass";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r7/3C5DzXP+9w4rp9XwbP+/NK1axIP6s3Iiio1xRMbk=";
  };

  cargoHash = "sha256-g2w3lZXQ3Kg3ydKdFs8P2lOPfIkfTbAF0MhxsJoX/E4=";

  nativeBuildInputs = [
    cmake # for oqs build in the oqs-sys crate
    makeWrapper # for the rp shellscript
    pkg-config # let libsodium-sys-stable find libsodium
    removeReferencesTo
    rustPlatform.bindgenHook # for C-bindings in the crypto libs
  ];

  buildInputs = [
    bash # for patchShebangs to find it
    libsodium
  ];

  # otherwise pkg-config tries to link non-existent dynamic libs during the build of liboqs
  PKG_CONFIG_ALL_STATIC = true;

  # liboqs requires quite a lot of stack memory, thus we adjust the default stack size picked for
  # new threads (which is used by `cargo test`) to be _big enough_
  RUST_MIN_STACK = 8 * 1024 * 1024; # 8 MiB

  # nix defaults to building for aarch64 _without_ the armv8-a
  # crypto extensions, but liboqs depends on these
  preBuild = lib.optionalString targetPlatform.isAarch
    ''NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -march=armv8-a+crypto"'';

  preInstall = ''
    install -D rp $out/bin/rp
    wrapProgram $out/bin/rp --prefix PATH : "${ rpBinPath }"
    for file in doc/*.1
    do
      install -D $file $out/share/man/man1/''${file##*/}
    done
  '';

  # nix propagates the *.dev outputs of buildInputs for static builds, but that is non-sense for an
  # executables only package
  postFixup = ''
    find -type f -exec remove-references-to -t ${bash.dev} \
      -t ${libsodium.dev} {} \;
  '';

  meta = with lib; {
    description = "Build post-quantum-secure VPNs with WireGuard!";
    homepage = "https://rosenpass.eu/";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
