{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  patchelf,
  zlib,
  pkg-config,
  openssl,
  xz,
  replaceVars,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustup-toolchain-install-master";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "kennytm";
    repo = "rustup-toolchain-install-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rcA+kZ53FdrImgQe9vIuSPXyU2i+akyYny+/kgRG6Zk=";
  };

  cargoHash = "sha256-rK+SSZ/EoaQflxkzhnxAab/AnJvpnEYb5RbwcR4VUow=";

  patches = lib.optional stdenv.hostPlatform.isLinux (
    replaceVars ./0001-dynamically-patchelf-binaries.patch {
      inherit patchelf;
      dynamicLinker = "${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2";
      libPath = lib.makeLibraryPath [
        zlib
        (placeholder "out" + "/lib")
      ];
    }
  );

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    xz
  ];

  meta = {
    description = "Install a rustc master toolchain usable from rustup";
    mainProgram = "rustup-toolchain-install-master";
    homepage = "https://github.com/kennytm/rustup-toolchain-install-master";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quio ];
  };
})
