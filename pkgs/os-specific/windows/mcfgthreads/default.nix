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
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    tag = "v${lib.versions.majorMinor finalAttrs.version}-ga.${lib.versions.patch finalAttrs.version}";
    hash = "sha256-KjZqFaTbPhdI87j11ugSu6Yoe+Rf473+AwopaIfNrKY=";
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

  # A libgcc built against this library gets the "mcf" threading model, which
  # on Windows beats the "win32" model the bare libc offers. Same attribute a
  # libc uses to declare what it provides; see `threadModel` in
  # pkgs/development/compilers/gcc/ng/common/libgcc/default.nix.
  passthru.threadModel = "mcf";

  meta = {
    description = "Threading support library for Windows 7 and above";
    homepage = "https://github.com/lhmouse/mcfgthread/wiki";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    teams = [ lib.teams.windows ];
    platforms = lib.platforms.windows;
  };
})
