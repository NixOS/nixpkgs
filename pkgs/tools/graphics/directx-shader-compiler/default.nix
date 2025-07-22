{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "directx-shader-compiler";
  version = "1.8.2505.1";

  # Put headers in dev, there are lot of them which aren't necessary for
  # using the compiler binary.
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXShaderCompiler";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d8qJ9crS5CStbsGOe/OSHtUEV4vr3sLCQp+6KsEq/A4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    ninja
    python3
  ];

  cmakeFlags = [ "-C../cmake/caches/PredefinedParams.cmake" ];

  # The default install target installs heaps of LLVM stuff.
  #
  # Upstream issue: https://github.com/microsoft/DirectXShaderCompiler/issues/3276
  #
  # The following is based on the CI script:
  # https://github.com/microsoft/DirectXShaderCompiler/blob/master/appveyor.yml#L63-L66
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $dev/include
    mv bin/{dxc,dxv}* $out/bin/
    mv lib/lib*.so* lib/lib*.*dylib $out/lib/
    cp -r $src/include/dxc $dev/include/
    runHook postInstall
  '';

  meta = {
    description = "Compiler to compile HLSL programs into DXIL and SPIR-V";
    homepage = "https://github.com/microsoft/DirectXShaderCompiler";
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
})
