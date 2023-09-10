{
    lib
  , stdenv
  , fetchFromGitHub
  , llvmPackages
  , cmake
  , makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "clazy";
  version = "1.11";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "clazy";
    rev    = "v${version}";
    sha256 = "sha256-kcl4dUg84fNdizKUS4kpvIKFfajtTRdz+MYUbKcMFvg=";
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

  meta = {
    description = "Qt-oriented static code analyzer based on the Clang framework";
    homepage = "https://github.com/KDE/clazy";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.cadkin ];
    platforms = lib.platforms.linux;
  };

}
