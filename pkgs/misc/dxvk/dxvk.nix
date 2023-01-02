{ lib
, stdenv
, fetchFromGitHub
, glslang
, meson
, ninja
, windows
, src
, version
, spirv-headers
, vulkan-headers
, dxvkPatches
}:

let
  # DXVK 2.0+ no longer vendors certain dependencies. This derivation also needs to build on Darwin,
  # which does not currently support DXVK 2.0, so adapt conditionally for this situation.
  isDxvk2 = lib.versionAtLeast version "2.0";
in
stdenv.mkDerivation {
  pname = "dxvk";
  inherit src version;

  nativeBuildInputs = [ glslang meson ninja ];
  buildInputs = [ windows.pthreads ]
    ++ lib.optionals isDxvk2 [ spirv-headers vulkan-headers ];

  patches = dxvkPatches;

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
