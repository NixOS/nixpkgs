{ mkDerivation, lib, hostVersion, symlinkJoin, bsdSetupHook, freebsdSetupHook, bmakeMinimal, install, tsort, lorder, mandoc, groff, localedef,
allLocales ? true, locales ? [ "en_US.UTF-8" ] }:
let
  build = name: needsLocaledef: mkDerivation {
    path = "share/${name}";

    extraPaths = lib.optional needsLocaledef "tools/tools/locale/etc/final-maps" ;
    nativeBuildInputs = [
      bsdSetupHook freebsdSetupHook
      bmakeMinimal
      install tsort lorder mandoc groff
    ] ++ lib.optional needsLocaledef localedef;
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
