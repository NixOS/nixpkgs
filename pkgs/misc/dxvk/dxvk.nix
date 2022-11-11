{ lib
, stdenv
, fetchFromGitHub
, glslang
, meson
, ninja
, windows
, src
, version
, dxvkPatches
}:

stdenv.mkDerivation {
  pname = "dxvk";
  inherit src version;

  nativeBuildInputs = [ glslang meson ninja ];
  buildInputs = [ windows.pthreads ];

  patches = dxvkPatches;

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
