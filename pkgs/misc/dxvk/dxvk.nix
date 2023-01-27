{ lib
, stdenv
, fetchFromGitHub
, glslang
, meson
, ninja
, windows
, dxvkVersion
, spirv-headers
, vulkan-headers
}:

let
  # DXVK 2.0+ no longer vendors certain dependencies. This derivation also needs to build on Darwin,
  # which does not currently support DXVK 2.0, so adapt conditionally for this situation.
  isDxvk2 = lib.versionAtLeast (srcs.${dxvkVersion}.version) "2.0";

  # DXVK has effectively the same build script regardless of platform.
  srcs = {
    "1.10" = rec {
      version = "1.10.3";
      src = fetchFromGitHub {
        owner = "doitsujin";
        repo = "dxvk";
        rev = "v${version}";
        hash = "sha256-T93ZylxzJGprrP+j6axZwl2d3hJowMCUOKNjIyNzkmE=";
      };
      # These patches are required when using DXVK with Wine on Darwin.
      patches = lib.optionals stdenv.buildPlatform.isDarwin [
        # Patch DXVK to work with MoltenVK even though it doesn’t support some required features.
        # Some games work poorly (particularly Unreal Engine 4 games), but others work pretty well.
        ./darwin-dxvk-compat.patch
        # Use synchronization primitives from the C++ standard library to avoid deadlocks on Darwin.
        # See: https://www.reddit.com/r/macgaming/comments/t8liua/comment/hzsuce9/
        ./darwin-thread-primitives.patch
      ];
    };
    "2.0" = rec {
      version = "2.0";
      src = fetchFromGitHub {
        owner = "doitsujin";
        repo = "dxvk";
        rev = "v${version}";
        hash = "sha256-mboVLdPgZMzmqyeF0jAloEz6xqfIDiY/X98e7l2KZnw=";
      };
      patches = [ ];
    };
  };
in
stdenv.mkDerivation {
  pname = "dxvk";
  inherit (srcs.${dxvkVersion}) version src patches;

  nativeBuildInputs = [ glslang meson ninja ];
  buildInputs = [ windows.pthreads ]
    ++ lib.optionals isDxvk2 [ spirv-headers vulkan-headers ];

  preConfigure = lib.optionalString isDxvk2 ''
    ln -s ${lib.getDev spirv-headers}/include include/spirv/include
    ln -s ${lib.getDev vulkan-headers}/include include/vulkan/include
  '';

  mesonFlags =
    let
      arch = if stdenv.is32bit then "32" else "64";
    in
    [
      "--buildtype" "release"
      "--cross-file" "build-win${arch}.txt"
      "--prefix" "${placeholder "out"}"
    ];

  meta = {
    description = "A Vulkan-based translation layer for Direct3D 9/10/11";
    homepage = "https://github.com/doitsujin/dxvk";
    changelog = "https://github.com/doitsujin/dxvk/releases";
    maintainers = [ lib.maintainers.reckenrode ];
    license = lib.licenses.zlib;
    platforms = lib.platforms.windows;
  };
}
