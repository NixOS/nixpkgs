{ stdenv
, mkDerivation
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
, kcrash
, kconfig
, kinit
, kparts
, kiconthemes
, undmg
}:

let
  pname = "kdiff3";
  version = "1.8.5";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
      sha256 = "sha256-vJL30E6xI/nFbb4wR69nv3FSQPqZSHrB0czypF4IVME=";
    };
    x86_64-darwin = fetchurl {
      url = "https://download.kde.org/stable/${pname}/${pname}-${version}-macos-64.dmg";
      name = "${pname}-${version}.dmg"; # required due to "No such file or directory" error otherwise
      hash = "sha256-Fe7fbWjM0b6Kd7SLjtjrDm9/PIER8b5wkH1bwAATw18=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};

  meta = with lib; {
    homepage = "https://invent.kde.org/sdk/kdiff3";
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ peterhoeg aaschmid ];
    platforms = builtins.attrNames srcs;
  };

  linux = mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

    propagatedBuildInputs = [ kconfig kcrash kinit kparts kiconthemes ];
  };

  darwin = mkDerivation rec {
    inherit pname version src meta;

    sourceRoot = "${pname}.app"; # The image contains the .app and a symlink to /Applications.

    depsBuildBuild = [ undmg ];

    dontBuild = true;
    dontWrapQtApps = true;
    dontFixup = true; # fixes als `dylib` files which breaks kdiff3

    passthru = {
      binaryPath = "Applications/${sourceRoot}/Contents/MacOS/${pname}";
    };

    installPhase = ''
      mkdir -p "$out/Applications/${sourceRoot}"
      cp -ar . "$out/Applications/${sourceRoot}"
      chmod a+x "$out/${passthru.binaryPath}"
    '';
 };
in
if stdenv.isLinux
then linux
else darwin
