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
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "kennytm";
    repo = "rustup-toolchain-install-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ayc4rzlZ9sLKzRhVr1fpRD7bmwQL69rkQ2jXBAdUPI=";
  };

  cargoHash = "sha256-VxrtkZbi9BprQOQFxOIAYEoAtg0kqyL3C4ih/5RobZI=";

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

  meta = with lib; {
    description = "Install a rustc master toolchain usable from rustup";
    mainProgram = "rustup-toolchain-install-master";
    homepage = "https://github.com/kennytm/rustup-toolchain-install-master";
    license = licenses.mit;
    maintainers = [ ];
  };
})
