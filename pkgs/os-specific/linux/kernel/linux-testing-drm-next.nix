{ stdenv, buildPackages, fetchgit, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.5-2019-11-27";
  modDirVersion = "5.4.0-rc7";

  src = fetchgit {
    url = "https://anongit.freedesktop.org/git/drm/drm.git";
    rev = "acc61b8929365e63a3e8c8c8913177795aa45594";
    sha256 = "0zaxq57zz5jfyscfsq5gq0fx7mr2z9nqgyb2r0sydx33z7ddl4is";
  };

  extraMeta = {
    branch = "drm-next";
    hydraPlatforms = [];
  };
} // (args.argsOverride or {}))
