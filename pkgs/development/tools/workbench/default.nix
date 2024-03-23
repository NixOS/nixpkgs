{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, desktop-file-utils
, vte-gtk4
, gtksourceview5
, gjs
, libadwaita
, vala
, blueprint-compiler
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "workbench";
  version = "43.3";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Workbench";
    rev = "v${version}";
    hash = "sha256-T/aOOvb3DRu/T0+uFMf3sx46U5LT544NQ45TmEBnkAo=";
    fetchSubmodules = true;
  };

  patches = [
    # Do not copy files with source permissions into home directory while
    # running Workbench, see https://github.com/sonnyp/Workbench/pull/188
    (fetchpatch {
      url = "https://github.com/sonnyp/Workbench/commit/c553f932c952057674c3333e4af84044153b76d7.patch";
      hash = "sha256-pFj2LvqJE7uGhCYs6GL2a7tj4n2BBoKcPzD1K1JZ3Rs=";
      name = "do-not-copy-source-perms.patch";
    })
  ];

  postPatch = ''
    substituteInPlace src/meson.build --replace "/app/bin/blueprint-compiler" "blueprint-compiler"
    substituteInPlace troll/gjspack/bin/gjspack \
      --replace "#!/usr/bin/env -S gjs -m" "#!${gjs}/bin/gjs -m"
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/31168#issuecomment-341793501
    sed -e '2iimports.package._findEffectiveEntryPointName = () => "re.sonny.Workbench"' \
      -i $out/bin/re.sonny.Workbench
    gappsWrapperArgs+=(--prefix PATH : $out/bin)
  '';

  dontPatchShebangs = true;

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gjs
    gtksourceview5
    libadwaita
    vte-gtk4
  ];

  doCheck = true;

  meta = with lib; {
    description = "Learn and prototype with GNOME technologies";
    homepage = "https://github.com/sonnyp/Workbench";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };
}
