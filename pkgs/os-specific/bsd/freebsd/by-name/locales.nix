{ mkDerivation, lib, hostVersion, buildFreebsd, buildPackages, symlinkJoin,
allLocales ? true, locales ? [ "en_US.UTF-8" ], ... }:
let
  build = name: needsLocaledef: mkDerivation {
    path = "share/${name}";

    extraPaths = lib.optional needsLocaledef "tools/tools/locale/etc/final-maps" ;
    nativeBuildInputs = [
      buildPackages.bsdSetupHook buildFreebsd.freebsdSetupHook
      buildFreebsd.bmakeMinimal  # TODO bmake??
      buildFreebsd.install buildFreebsd.tsort buildFreebsd.lorder buildPackages.mandoc buildPackages.groff #statHook
    ] ++ lib.optional needsLocaledef buildFreebsd.localedef;
  };
  directories = {
    colldef = true;
    colldef_unicode = true;
    ctypedef = true;
    monetdef = false;
    monetdef_unicode = false;
    msgdef = false;
    msgdef_unicode = false;
    numericdef = false;
    numericdef_unicode = false;
    timedef = false;
  };
in
symlinkJoin {
  name = "freebsd-locales";
  version = hostVersion;

  paths = lib.mapAttrsToList build directories;
}
