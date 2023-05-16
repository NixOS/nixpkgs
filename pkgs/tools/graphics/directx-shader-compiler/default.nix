{ lib, stdenv, fetchFromGitHub, cmake, ninja, python3, git }:

stdenv.mkDerivation rec {
  pname = "directx-shader-compiler";
<<<<<<< HEAD
  version = "1.7.2308";
=======
  version = "1.7.2212.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Put headers in dev, there are lot of them which aren't necessary for
  # using the compiler binary.
  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXShaderCompiler";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pfdAD+kRpmqW29Y8jn6+X5Ujy/9cIvisYr0tH1PuxsY=";
=======
    hash = "sha256-old/vGNoj0mimuvd/RkwNeynBp+gBrkwQ7ah2oUZll0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git ninja python3 ];

  cmakeFlags = [ "-C../cmake/caches/PredefinedParams.cmake" ];

  # The default install target installs heaps of LLVM stuff.
  #
  # Upstream issue: https://github.com/microsoft/DirectXShaderCompiler/issues/3276
  #
  # The following is based on the CI script:
  # https://github.com/microsoft/DirectXShaderCompiler/blob/master/appveyor.yml#L63-L66
  installPhase = ''
    mkdir -p $out/bin $out/lib $dev/include
    mv bin/dxc* $out/bin/
    mv lib/libdxcompiler.so* lib/libdxcompiler.*dylib $out/lib/
    cp -r $src/include/dxc $dev/include/
  '';

  meta = with lib; {
    description = "A compiler to compile HLSL programs into DXIL and SPIR-V";
    homepage = "https://github.com/microsoft/DirectXShaderCompiler";
    platforms = with platforms; linux ++ darwin;
    license = licenses.ncsa;
    maintainers = with maintainers; [ expipiplus1 Flakebi ];
  };
}
