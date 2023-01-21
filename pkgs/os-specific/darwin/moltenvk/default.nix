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
  version = "1.2.0";

  buildInputs = [ AppKit Foundation Metal QuartzCore cereal ]
    ++ lib.attrValues finalAttrs.passthru;

  nativeBuildInputs = [ cctools sigtool xcbuild ];

  outputs = [ "out" "bin" "dev" ];

  # MoltenVK requires specific versions of its dependencies.
  # Pin them here except for cereal, which is four years old and has several CVEs.
  passthru = {
    glslang = (glslang.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "glslang";
        rev = "5755de46b07e4374c05fb1081f65f7ae1f8cca81";
        hash = "sha256-huPrQr+lPi7QCF8CufAavHEKGDDimGrcskiojhH9QYk=";
      };
      patches = [ ];
    })).override { inherit (finalAttrs.passthru) spirv-headers spirv-tools; };
    spirv-cross = spirv-cross.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or [ ])
        ++ [ "-DSPIRV_CROSS_NAMESPACE_OVERRIDE=MVK_spirv_cross" ];
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Cross";
        rev = "f09ba2777714871bddb70d049878af34b94fa54d";
        hash = "sha256-yVpLW1DbcHDuM9Bm3uGhAC0v9XjmpBoU9x7kmWdg6/o=";
      };
    });
    spirv-headers = spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "spirv-headers";
        rev = "85a1ed200d50660786c1a88d9166e871123cce39";
        hash = "sha256-lUWgZYGPu+IaLUrbtyC7R0o3Hq/q7C7BE8r7DAsiC30=";
      };
    });
    spirv-tools = (spirv-tools.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "spirv-tools";
        rev = "eb0a36633d2acf4de82588504f951ad0f2cecacb";
        hash = "sha256-sqjQoz9v9alSPc0ujEcWZxDAWh2S6oAPP1+JZmNCpA0=";
      };
    })).override { inherit (finalAttrs.passthru) spirv-headers; };
    vulkan-headers = vulkan-headers.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "Vulkan-Headers";
        rev = "98f440ce6868c94f5ec6e198cc1adda4760e8849";
        hash = "sha256-EoD48jBoJmIet4BDC6bYxOsKK2358SZ/NcZeM61q/5g=";
      };
    });
  };

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "MoltenVK";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PqrKGNGw7nJbirRgIargIV6Jbgoblu+2fn5qdHKI6BI=";
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
    # Adding all of `usr/include` from the SDK results in header conflicts with `libcxx.dev`.
    # Work around it by symlinking just the SIMD stuff needed by MoltenVK.
    mkdir -p build/include
    ln -s "${MacOSX-SDK}/usr/include/simd" "build/include"
  '';

  dontConfigure = true;

  NIX_CFLAGS_COMPILE = [
    "-isystem ${lib.getDev libcxx}/include/c++/v1"
    "-I${finalAttrs.passthru.spirv-cross}/include/spirv_cross"
    "-I${finalAttrs.passthru.spirv-headers}/include/spirv/unified1/"
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
