{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  rapidjson,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "ccls";
  version = "0.20240202";

  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = version;
    sha256 = "sha256-xVx3+cnmIdoA7R1S31EaiPj+DOTqkINoQeMgauW61Ys=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];
  buildInputs = with llvmPackages; [
    libclang
    llvm
    rapidjson
  ];

  cmakeFlags = [ "-DCCLS_VERSION=${version}" ];

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_CXX_FLAGS="-fvisibility=hidden -fno-rtti")
  '';

  clang = llvmPackages.clang;
  shell = runtimeShell;

  postFixup = ''
    export wrapped=".ccls-wrapped"
    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = with lib; {
    description = "C/c++ language server powered by clang";
    mainProgram = "ccls";
    homepage = "https://github.com/MaskRay/ccls";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      mic92
      tobim
    ];
  };
}
