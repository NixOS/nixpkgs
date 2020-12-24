{ stdenv, fetchFromGitHub, cmake, python3, git }:

stdenv.mkDerivation rec {
  pname = "directx-shader-compiler";
  version = "1.5.2010";

  # Put headers in dev, there are lot of them which aren't necessary for
  # using the compiler binary.
  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXShaderCompiler";
    rev = "v${version}";
    sha256 = "0ccfy1bfp0cm0pq63ri4yl1sr3fdn1a526bsnakg4bl6z4fwrnnj";
    # We rely on the side effect of leaving the .git directory here for the
    # version-grabbing functionality of the build system.
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git python3 ];

  configurePhase = ''
    # Requires some additional flags to cmake from a file in the repo
    additionalCMakeFlags=$(< utils/cmake-predefined-config-params)
    cmakeFlags="$additionalCMakeFlags''${cmakeFlags:+ $cmakeFlags}"
    cmakeConfigurePhase
  '';

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

  meta = with stdenv.lib; {
    description = "A compiler to compile HLSL programs into DXIL and SPIR-V";
    homepage = "https://github.com/microsoft/DirectXShaderCompiler";
    platforms = with platforms; linux ++ darwin;
    license = licenses.ncsa;
    maintainers = with maintainers; [ expipiplus1 ];
  };
}
