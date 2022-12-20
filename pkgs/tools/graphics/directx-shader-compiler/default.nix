{ lib, stdenv, fetchFromGitHub, cmake, ninja, python3, git }:

stdenv.mkDerivation rec {
  pname = "directx-shader-compiler";
  version = "1.7.2212";

  # Put headers in dev, there are lot of them which aren't necessary for
  # using the compiler binary.
  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXShaderCompiler";
    rev = "v${version}";
    hash = "sha256-/FuG6ThvA3XMlHhnshRJpKC+vf4LM8/hurUoPagpTqA=";
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
