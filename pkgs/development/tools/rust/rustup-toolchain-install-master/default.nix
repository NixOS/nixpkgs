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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "kennytm";
    repo = "rustup-toolchain-install-master";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F2lMUNl+ZQTTaSpzzeIl6ijXou7J6tbPz6eQY9703qU=";
  };

  cargoHash = "sha256-yEIkiOn8FTyfoTBFdbdJAfolgai8VFnnwSl/a8vDqbY=";

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
