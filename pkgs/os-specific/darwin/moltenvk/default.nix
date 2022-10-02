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
  version = "1.1.11";

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
        rev = "73c9630da979017b2f7e19c6549e2bdb93d9b238";
        hash = "sha256-+NKp/4e3iruAcTunpxksvCHxoVYmPd0kFI8JDJJUVg4=";
      };
    })).override { inherit (finalAttrs.passthru) spirv-headers spirv-tools; };
    spirv-cross = spirv-cross.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or [ ])
        ++ [ "-DSPIRV_CROSS_NAMESPACE_OVERRIDE=MVK_spirv_cross" ];
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Cross";
        rev = "61c603f3baa5270e04bcfb6acf83c654e3c57679";
        hash = "sha256-gV5ba8SlPmkUptZkQfrrEDoFXrFTfs3eVOf807cO/f8=";
      };
    });
    spirv-headers = spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "spirv-headers";
        rev = "b2a156e1c0434bc8c99aaebba1c7be98be7ac580";
        hash = "sha256-qYhFoRrQOlvYvVXhIFsa3dZuORDpZyVC5peeYmGNimw=";
      };
    });
    spirv-tools = (spirv-tools.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "spirv-tools";
        rev = "5e61ea2098220059e89523f1f47b0bcd8c33b89a";
        hash = "sha256-jpVvjrNrTAKUY4sjUT/gCUElLtW4BrznH1DbStojGB8=";
      };
    })).override { inherit (finalAttrs.passthru) spirv-headers; };
    vulkan-headers = vulkan-headers.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "Vulkan-Headers";
        rev = "c896e2f920273bfee852da9cca2a356bc1c2031e";
        hash = "sha256-zUT5+Ttmkrj51a9FS1tQxoYMS0Y0xV8uaCEJNur4khc=";
      };
    });
  };

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "MoltenVK";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+/vlZvEuake0E2jFZOcctEVGMCcXelGPQJXt1EI06us=";
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
