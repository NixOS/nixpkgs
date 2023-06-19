{ stdenv
, lib
, fetchFromGitHub
, cmake
, llvmPackages_15
, unstableGitUpdater
}:

let
  c2ffiBranch = "llvm-15.0.0";
  llvmPackages = llvmPackages_15;
in

llvmPackages.stdenv.mkDerivation {
  pname = "c2ffi-${c2ffiBranch}";
  version = "unstable-2023-06-08";

  src = fetchFromGitHub {
    owner = "rpav";
    repo = "c2ffi";
    rev = "3078cb57ccfa43736aa93720a72f1074034cb37d";
    sha256 = "sha256-q4TWNJF6mtVUJ/97NSS6Eep2aSYDU5UbOC+wcrBW610";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/rpav/c2ffi.git";
    branch = c2ffiBranch;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.clang
    llvmPackages.libclang
  ];

  # This isn't much, but...
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/c2ffi --help 2>&1 >/dev/null
  '';

  # LLVM may be compiled with -fno-rtti, so let's just turn it off.
  # A mismatch between lib{clang,LLVM}* and us can lead to the link time error:
  # undefined reference to `typeinfo for clang::ASTConsumer'
  CXXFLAGS="-fno-rtti";

  meta = with lib; {
    homepage = "https://github.com/rpav/c2ffi";
    description = "An LLVM based tool for extracting definitions from C, C++, and Objective C header files for use with foreign function call interfaces";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ attila-lendvai ];
    meta.broken = stdenv.hostPlatform.isDarwin;
 };
}
