{
  lib,
  stdenv,
  writeScriptBin,
  fetchFromGitHub,
  meson,
  ninja,
}:
let
  dllTool = writeScriptBin "dlltool" ''
    ${stdenv.cc.targetPrefix}dlltool "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mcfgthread";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    tag = "v${lib.versions.majorMinor finalAttrs.version}-ga.${lib.versions.patch finalAttrs.version}";
    hash = "sha256-kEqS1+2CB/Ryor2WbI67KALnlTcD9oSFEdC6Av73roE=";
  };

  postPatch = ''
    sed -z "s/Rules for tests.*//;s/'cpp'/'c'/g" -i meson.build
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    dllTool
    meson
    ninja
  ];

  meta = {
    description = "Threading support library for Windows 7 and above";
    homepage = "https://github.com/lhmouse/mcfgthread/wiki";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    teams = [ lib.teams.windows ];
    platforms = lib.platforms.windows;
  };
})
