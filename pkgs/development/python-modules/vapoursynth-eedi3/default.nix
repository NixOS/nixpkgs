{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  meson-python,
  vapoursynth,
}:

buildPythonPackage (finalAttrs: {
  pname = "vapoursynth-eedi3";
  version = "10";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "HolyWu";
    repo = "VapourSynth-EEDI3";
    rev = "r${finalAttrs.version}";
    hash = "sha256-figlALEzlATwuwFNo5rGcMjunt2W5R/hQHjwsveNbdY=";
  };

  build-system = [ meson-python ];

  buildInputs = [ vapoursynth ];

  postPatch = ''
    # Fix missing FLT_MAX
    sed -i EEDI3/EEDI3.h -e '3i #include <cfloat>'
  '';

  mesonFlags = [
    "-Db_lto=false" # fails with undefined symbols if on
  ];

  meta = {
    description = "Filter for VapourSynth";
    homepage = "https://github.com/HolyWu/VapourSynth-EEDI3";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
})
