{ lib
, stdenv
, stdenvNoCC
, fetchurl
, fetchFromGitHub
, cctools
, sigtool
, cereal
, glslang
, spirv-cross
, spirv-headers
, spirv-tools
, vulkan-headers
, AppKit
, Foundation
, Metal
, QuartzCore
}:

# Even though the derivation is currently impure, it is written to build successfully using
# `xcbuild`.  Once the SDK on x86_64-darwin is updated, it should be possible to switch from being
# an impure derivation.
#
# The `sandboxProfile` was copied from the iTerm2 derivation.  In order to build you at least need
# the `sandbox` option set to `relaxed` or `false`.  Xcode should be available in the default
# location.
let
  libcxx.dev = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr";
in
stdenvNoCC.mkDerivation rec {
  pname = "MoltenVK";
  version = "1.1.8";

  buildInputs = [
    AppKit
    Foundation
    Metal
    QuartzCore
  ];

  outputs = [ "out" "bin" ];

  # MoltenVK requires specific versions of its dependencies.
  # Pin them here except for cereal, which is four years old and has several CVEs.
  passthru = {
    glslang = (glslang.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "glslang";
        rev = "90d4bd05cd77ef5782a6779a0fe3d084440dc80d";
        hash = "sha256-Q0sk4bPj/skPat1n4GJyuXAlZqpfEn4Td8Bm2IBNUqE=";
      };
    })).override {
      inherit (passthru) spirv-headers spirv-tools;
    };
    spirv-cross = spirv-cross.overrideAttrs (old: {
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        "-DSPIRV_CROSS_NAMESPACE_OVERRIDE=MVK_spirv_cross"
      ];
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Cross";
        rev = "131278458ea8eebe6a6e9c476fbcf71278726e1a";
        hash = "sha256-LrRYDFGv3Zxfy4qRNLwM2OOa8jbcq0ttPxDamCH21xU=";
      };
    });
    spirv-headers = spirv-headers.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "spirv-headers";
        rev = "b42ba6d92faf6b4938e6f22ddd186dbdacc98d78";
        hash = "sha256-ks9JCj5rj+Xu++7z5RiHDkU3/sFXhcScw8dATfB/ot0";
      };
    });
    spirv-tools = (spirv-tools.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "spirv-tools";
        rev = "45dd184c790d6bfc78a5a74a10c37e888b1823fa";
        hash = "sha256-DSqZlwfNTbN4fyIrVBKltm5U2U4GthW3L+Ksw4lSVG8=";
      };
      meta = old.meta // {
        platforms = old.meta.platforms ++ lib.platforms.darwin;
      };
    })).override {
      inherit (passthru) spirv-headers;
    };
    vulkan-headers = vulkan-headers.overrideAttrs (old: {
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "Vulkan-Headers";
        rev = "1dace16d8044758d32736eb59802d171970e9448";
        hash = "sha256-C6YgxWcinI3QumcWmoJaiTAf0u6jSDc8sCIarn2t04k";
      };
      meta = old.meta // {
        platforms = old.meta.platforms ++ lib.platforms.darwin;
      };
    });
  };

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "MoltenVK";
    rev = "v${version}";
    hash = "sha256-IfTBtA2fM7YN4qaSDUTfsiCXzn+omSV6oroL1ivKiVA=";
  };

  patches = [
    # Specify the libraries to link directly since XCFrameworks are not being used.
    ./createDylib.patch
    # Move `mvkGitRevDerived.h` to a stable location
    ./gitRevHeaderStability.patch
    # Fix the Xcode projects to play nicely with `xcbuild`.
    ./MoltenVKShaderConverter.xcodeproj.patch
    ./MoltenVK.xcodeproj.patch
  ];

  postPatch = ''
    substituteInPlace MoltenVKShaderConverter/MoltenVKShaderConverter.xcodeproj/project.pbxproj \
      --replace @@sourceRoot@@ $(pwd) \
      --replace @@libcxx@@ "${libcxx.dev}" \
      --replace @@glslang@@ "${passthru.glslang}" \
      --replace @@spirv-cross@@ "${passthru.spirv-cross}" \
      --replace @@spirv-tools@@ "${passthru.glslang.spirv-tools}" \
      --replace @@spirv-headers@@ "${passthru.glslang.spirv-headers}"
    substituteInPlace MoltenVK/MoltenVK.xcodeproj/project.pbxproj \
      --replace @@sourceRoot@@ $(pwd) \
      --replace @@libcxx@@ "${libcxx.dev}" \
      --replace @@cereal@@ "${cereal}" \
      --replace @@spirv-cross@@ "${passthru.spirv-cross}" \
      --replace @@vulkan-headers@@ "${passthru.vulkan-headers}"
    substituteInPlace Scripts/create_dylib.sh \
      --replace @@sourceRoot@@ $(pwd) \
      --replace @@glslang@@ "${passthru.glslang}" \
      --replace @@spirv-tools@@ "${passthru.glslang.spirv-tools}" \
      --replace @@spirv-cross@@ "${passthru.spirv-cross}"
    substituteInPlace Scripts/gen_moltenvk_rev_hdr.sh \
      --replace @@sourceRoot@@ $(pwd) \
      --replace '$(git rev-parse HEAD)' ${src.rev}
  '';

  dontConfigure = true;

  buildPhase = ''
    # Build each project on its own because `xcbuild` fails to build `MoltenVKPackaging.xcodeproj`.
    derived_data_path=$(pwd)/DerivedData
    pushd MoltenVKShaderConverter
      /usr/bin/xcodebuild build \
        -jobs $NIX_BUILD_CORES \
        -derivedDataPath "$derived_data_path" \
        -configuration Release \
        -project MoltenVKShaderConverter.xcodeproj \
        -scheme MoltenVKShaderConverter \
        -arch ${stdenv.targetPlatform.darwinArch}
    popd
    mkdir -p outputs/bin outputs/lib
    declare -A outputs=( [MoltenVKShaderConverter]=bin [libMoltenVKShaderConverter.a]=lib )
    for output in "''${!outputs[@]}"; do
      cp DerivedData/Build/Products/Release/$output "outputs/''${outputs[$output]}/$output"
    done

    pushd MoltenVK
      /usr/bin/xcodebuild build \
        -jobs $NIX_BUILD_CORES \
        -derivedDataPath "$derived_data_path" \
        -configuration Release \
        -project MoltenVK.xcodeproj \
        -scheme MoltenVK-macOS \
        -arch ${stdenv.targetPlatform.darwinArch}
    popd
    cp DerivedData/Build/Products/Release/dynamic/libMoltenVK.dylib outputs/lib/libMoltenVK.dylib
  '';

  installPhase = ''
    mkdir -p "$out/lib" "$out/share/vulkan/icd.d" "$bin/bin"
    cp outputs/bin/MoltenVKShaderConverter "$bin/bin/"
    cp outputs/lib/libMoltenVK.dylib "$out/lib/"
    ${cctools}/bin/install_name_tool -id "$out/lib/libMoltenVK.dylib" "$out/lib/libMoltenVK.dylib"
    # FIXME: https://github.com/NixOS/nixpkgs/issues/148189
    /usr/bin/codesign -s - -f "$out/lib/libMoltenVK.dylib"
    install -m644 MoltenVK/icd/MoltenVK_icd.json "$out/share/vulkan/icd.d/MoltenVK_icd.json"
    substituteInPlace $out/share/vulkan/icd.d/MoltenVK_icd.json \
      --replace ./libMoltenVK.dylib "$out/share/vulkan/icd.d/MoltenVK_icd.json"
  '';

  sandboxProfile = ''
    (allow file-read* file-write* process-exec mach-lookup)
    ; block homebrew dependencies
    (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = {
    description = "A Vulkan Portability implementation built on top of Apple’s Metal API";
    homepage = "https://github.com/KhronosGroup/MoltenVK";
    changelog = "https://github.com/KhronosGroup/MoltenVK/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
  };
}
