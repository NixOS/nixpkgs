{ lib
, fetchFromGitHub
, cmake
, llvmPackages_11
, unstableGitUpdater
}:

let
  c2ffiBranch = "llvm-11.0.0";
  llvmPackages = llvmPackages_11;
in

llvmPackages.stdenv.mkDerivation {
  pname = "c2ffi-${c2ffiBranch}";
  version = "unstable-2021-06-15";

  src = fetchFromGitHub {
    owner = "rpav";
    repo = "c2ffi";
    rev = "f50243926a0afb589de1078a073ac08910599582";
    sha256 = "UstGicFzFY0/Jge5HGYTPwYSnh9OUBY5346ObZYfR54=";
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
 };
}
