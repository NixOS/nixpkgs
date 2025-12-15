{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  cmake,
  makeWrapper,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clazy";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "clazy";
    tag = finalAttrs.version;
    hash = "sha256-i/tqH2RHU+LwvMFI8ft92j0i04mQxLVIyrGXlqzMGWs=";
  };

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/clazy \
      --suffix PATH               : "${llvmPackages.clang}/bin/"                            \
      --suffix CPATH              : "$(<${llvmPackages.clang}/nix-support/libc-cflags)"     \
      --suffix CPATH              : "${llvmPackages.clang}/resource-root/include"           \
      --suffix CPLUS_INCLUDE_PATH : "$(<${llvmPackages.clang}/nix-support/libcxx-cxxflags)" \
      --suffix CPLUS_INCLUDE_PATH : "$(<${llvmPackages.clang}/nix-support/libc-cflags)"     \
      --suffix CPLUS_INCLUDE_PATH : "${llvmPackages.clang}/resource-root/include"

    wrapProgram $out/bin/clazy-standalone \
      --suffix CPATH              : "$(<${llvmPackages.clang}/nix-support/libc-cflags)"     \
      --suffix CPATH              : "${llvmPackages.clang}/resource-root/include"           \
      --suffix CPLUS_INCLUDE_PATH : "$(<${llvmPackages.clang}/nix-support/libcxx-cxxflags)" \
      --suffix CPLUS_INCLUDE_PATH : "$(<${llvmPackages.clang}/nix-support/libc-cflags)"     \
      --suffix CPLUS_INCLUDE_PATH : "${llvmPackages.clang}/resource-root/include"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Qt-oriented static code analyzer based on the Clang framework";
    homepage = "https://github.com/KDE/clazy";
    changelog = "https://github.com/KDE/clazy/blob/${finalAttrs.version}/Changelog";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.linux;
  };
})
