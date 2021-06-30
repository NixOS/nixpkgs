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
  version = "unstable-2021-04-15";

  src = fetchFromGitHub {
    owner = "rpav";
    repo = "c2ffi";
    rev = "0255131f80b21334e565231331c2b451b6bba8c4";
    sha256 = "0ihysgqjyg5xwi098hxf15lpdi6g4nwpzczp495is912c48fy6b6";
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
