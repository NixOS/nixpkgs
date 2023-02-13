{ lib
, overrideCC
, stdenv
, fetchurl
, fetchFromGitHub
, cctools
, sigtool
, cereal
, libcxx
, glslang
, spirv-cross
, spirv-headers
, spirv-tools
, vulkan-headers
, xcbuild
, AppKit
, Foundation
, Libsystem
, MacOSX-SDK
, Metal
, QuartzCore
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "MoltenVK";
  version = "1.2.1";

  buildInputs = [
    AppKit
    Foundation
    Metal
    QuartzCore
    cereal
    glslang
    spirv-cross
    spirv-headers
    spirv-tools
    vulkan-headers
  ];

  nativeBuildInputs = [ cctools sigtool xcbuild ];

  outputs = [ "out" "bin" "dev" ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "MoltenVK";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JqHPKLSFq+8hyOjVZbjh4AsHM8zSF7ZVxlEePmnEC2w=";
  };

  patches = [
    # Fix the Xcode projects to play nicely with `xcbuild`.
    ./MoltenVKShaderConverter.xcodeproj.patch
    ./MoltenVK.xcodeproj.patch
  ];

  postPatch = ''
    # Move `mvkGitRevDerived.h` to a stable location
    substituteInPlace Scripts/gen_moltenvk_rev_hdr.sh \
      --replace '$'''{BUILT_PRODUCTS_DIR}' "$NIX_BUILD_TOP/$sourceRoot/build/include" \
      --replace '$(git rev-parse HEAD)' ${finalAttrs.src.rev}
    # Use the SPIRV-Cross packaged in nixpkgs instead of one built specifically for MoltenVK.
    substituteInPlace MoltenVK/MoltenVK.xcodeproj/project.pbxproj \
      --replace SPIRV_CROSS_NAMESPACE_OVERRIDE=MVK_spirv_cross SPIRV_CROSS_NAMESPACE_OVERRIDE=spirv_cross
    substituteInPlace MoltenVKShaderConverter/MoltenVKShaderConverter.xcodeproj/project.pbxproj \
      --replace SPIRV_CROSS_NAMESPACE_OVERRIDE=MVK_spirv_cross SPIRV_CROSS_NAMESPACE_OVERRIDE=spirv_cross
    # Adding all of `usr/include` from the SDK results in header conflicts with `libcxx.dev`.
    # Work around it by symlinking just the SIMD stuff needed by MoltenVK.
    mkdir -p build/include
    ln -s "${MacOSX-SDK}/usr/include/simd" "build/include"
  '';

  dontConfigure = true;

  NIX_CFLAGS_COMPILE = [
    "-isystem ${lib.getDev libcxx}/include/c++/v1"
    "-I${lib.getDev spirv-cross}/include/spirv_cross"
    "-I${lib.getDev spirv-headers}/include/spirv/unified1/"
  ];

  buildPhase = ''
    NIX_CFLAGS_COMPILE+=" \
      -I$NIX_BUILD_TOP/$sourceRoot/build/include \
      -I$NIX_BUILD_TOP/$sourceRoot/Common"
    NIX_LDFLAGS+=" -L$NIX_BUILD_TOP/$sourceRoot/build/lib"

    # Build each project on its own because `xcbuild` fails to build `MoltenVKPackaging.xcodeproj`.
    build=$NIX_BUILD_TOP/$sourceRoot/build
    mkdir -p "$build/bin" "$build/lib"

    NIX_LDFLAGS+=" \
      -lMachineIndependent \
      -lGenericCodeGen \
      -lOGLCompiler \
      -lglslang \
      -lOSDependent \
      -lSPIRV \
      -lSPIRV-Tools \
      -lSPIRV-Tools-opt \
      -lspirv-cross-msl \
      -lspirv-cross-core \
      -lspirv-cross-glsl"

    pushd MoltenVKShaderConverter
    xcodebuild build \
      -jobs $NIX_BUILD_CORES \
      -configuration Release \
      -project MoltenVKShaderConverter.xcodeproj \
      -scheme MoltenVKShaderConverter \
      -arch ${stdenv.targetPlatform.darwinArch}
    declare -A products=( [MoltenVKShaderConverter]=bin [libMoltenVKShaderConverter.a]=lib )
    for product in "''${!products[@]}"; do
      cp MoltenVKShaderConverter-*/Build/Products/Release/$product "$build/''${products[$product]}/$product"
    done
    popd

    NIX_LDFLAGS+=" \
      -lobjc \
      -lMoltenVKShaderConverter \
      -lspirv-cross-reflect"

    pushd MoltenVK
    xcodebuild build \
      -jobs $NIX_BUILD_CORES \
      -configuration Release \
      -project MoltenVK.xcodeproj \
      -scheme MoltenVK-macOS \
      -arch ${stdenv.targetPlatform.darwinArch}
    cp MoltenVK-*/Build/Products/Release/dynamic/libMoltenVK.dylib "$build/lib/libMoltenVK.dylib"
    popd
  '';

  installPhase = ''
    mkdir -p "$out/lib" "$out/share/vulkan/icd.d" "$bin/bin" "$dev/include/MoltenVK"
    cp build/bin/MoltenVKShaderConverter "$bin/bin/"
    cp build/lib/libMoltenVK.dylib "$out/lib/"
    cp MoltenVK/MoltenVK/API/* "$dev/include/MoltenVK"
    install -m644 MoltenVK/icd/MoltenVK_icd.json "$out/share/vulkan/icd.d/MoltenVK_icd.json"
    substituteInPlace $out/share/vulkan/icd.d/MoltenVK_icd.json \
      --replace ./libMoltenVK.dylib "$out/lib/libMoltenVK.dylib"
  '';

  postFixup = ''
    install_name_tool -id "$out/lib/libMoltenVK.dylib" "$out/lib/libMoltenVK.dylib"
    codesign -s - -f "$out/lib/libMoltenVK.dylib"
  '';

  meta = {
    description = "A Vulkan Portability implementation built on top of Apple’s Metal API";
    homepage = "https://github.com/KhronosGroup/MoltenVK";
    changelog = "https://github.com/KhronosGroup/MoltenVK/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
  };
})
