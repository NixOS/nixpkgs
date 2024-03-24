self: {
  lib,
  stdenv,
  makeSetupHook,
  fetchurl,
  cmake,
  qt6,
}: let
  dependencies = (lib.importJSON ../generated/dependencies.json).dependencies;
  projectInfo = lib.importJSON ../generated/projects.json;

  licenseInfo = lib.importJSON ../generated/licenses.json;
  licensesBySpdxId =
    (lib.mapAttrs' (_: v: {
        name = v.spdxId or "unknown";
        value = v;
      })
      lib.licenses)
    // {
      # https://community.kde.org/Policies/Licensing_Policy
      "LicenseRef-KDE-Accepted-GPL" = lib.licenses.gpl3Plus;
      "LicenseRef-KFQF-Accepted-GPL" = lib.licenses.gpl3Plus;
      "LicenseRef-KDE-Accepted-LGPL" = lib.licenses.lgpl3Plus;

      # https://sjfonts.sourceforge.net/
      "LicenseRef-SJFonts" = lib.licenses.gpl2Plus;

      # https://invent.kde.org/education/kiten/-/blob/master/LICENSES/LicenseRef-EDRDG.txt
      "LicenseRef-EDRDG" = lib.licenses.cc-by-sa-30;

      # https://invent.kde.org/kdevelop/kdevelop/-/blob/master/LICENSES/LicenseRef-MIT-KDevelop-Ideal.txt
      "LicenseRef-MIT-KDevelop-Ideal" = lib.licenses.mit;

      "FSFAP" = {
        spdxId = "FSFAP";
        fullName = "FSF All Permissive License";
      };

      "FSFULLR" = {
        spdxId = "FSFULLR";
        fullName = "FSF Unlimited License (with License Retention)";
      };

      "W3C-20150513" = {
        spdxId = "W3C-20150513";
        fullName = "W3C Software Notice and Document License (2015-05-13)";
      };

      # Technically not exact
      "bzip2-1.0.6" = lib.licenses.bsdOriginal;

      # FIXME: typo lol
      "ICS" = lib.licenses.isc;

      # These are only relevant to Qt commercial users
      "Qt-Commercial-exception-1.0" = null;
      "LicenseRef-Qt-Commercial" = null;
      "LicenseRef-Qt-Commercial-exception-1.0" = null;

      # FIXME: ???
      "Qt-GPL-exception-1.0" = null;
      "LicenseRef-Qt-LGPL-exception-1.0" = null;
      "Qt-LGPL-exception-1.1" = null;
      "LicenseRef-Qt-exception" = null;
      "GCC-exception-3.1" = null;
      "Bison-exception-2.2" = null;
      "Font-exception-2.0" = null;
      None = null;
    };

  moveDevHook = makeSetupHook {name = "kf6-move-dev-hook";} ./move-dev-hook.sh;
in
  {
    pname,
    version ? self.sources.${pname}.version,
    src ? self.sources.${pname},
    extraBuildInputs ? [],
    extraNativeBuildInputs ? [],
    extraPropagatedBuildInputs ? [],
    extraCmakeFlags ? [],
    excludeDependencies ? [],
    ...
  } @ args: let
    depNames = dependencies.${pname} or [];
    filteredDepNames = builtins.filter (dep: !(builtins.elem dep excludeDependencies)) depNames;

    # FIXME(later): this is wrong for cross, some of these things really need to go into nativeBuildInputs,
    # but cross is currently very broken anyway, so we can figure this out later.
    deps = map (dep: self.${dep}) filteredDepNames;

    defaultArgs = {
      inherit version src;

      outputs = ["out" "dev"];

      nativeBuildInputs = [cmake qt6.wrapQtAppsHook moveDevHook] ++ extraNativeBuildInputs;
      buildInputs = [qt6.qtbase] ++ extraBuildInputs;

      # FIXME: figure out what to propagate here
      propagatedBuildInputs = deps ++ extraPropagatedBuildInputs;
      strictDeps = true;

      dontFixCmake = true;
      cmakeFlags = ["-DQT_MAJOR_VERSION=6"] ++ extraCmakeFlags;

      separateDebugInfo = true;

      env.LANG = "C.UTF-8";
    };

    cleanArgs = builtins.removeAttrs args [
      "extraBuildInputs"
      "extraNativeBuildInputs"
      "extraPropagatedBuildInputs"
      "extraCmakeFlags"
      "excludeDependencies"
      "meta"
    ];

    meta = {
      description = projectInfo.${pname}.description;
      homepage = "https://invent.kde.org/${projectInfo.${pname}.repo_path}";
      license = lib.filter (l: l != null) (map (l: licensesBySpdxId.${l}) licenseInfo.${pname});
      maintainers = lib.teams.qt-kde.members;
      # Platforms are currently limited to what upstream tests in CI, but can be extended if there's interest.
      platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    } // (args.meta or { });

    pos = builtins.unsafeGetAttrPos "pname" args;
  in
    stdenv.mkDerivation (defaultArgs // cleanArgs // { inherit meta pos; })
