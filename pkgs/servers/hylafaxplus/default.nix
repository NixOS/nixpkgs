{ stdenv
, lib
, fakeroot
, fetchurl
, libfaketime
, substituteAll
## runtime dependencies
, coreutils
, file
, findutils
, gawk
, ghostscript
, gnugrep
, gnused
, libtiff
, psmisc
, sharutils
, utillinux
, zlib
## optional packages (using `null` disables some functionality)
, jbigkit ? null
, lcms2 ? null  # for colored faxes
, openldap ? null
, pam ? null
## system-dependent settings that have to be hardcoded
, maxgid ? 65534  # null -> try to auto-detect (bad on linux)
, maxuid ? 65534  # null -> hardcoded value 60002
}:

let

  name = "hylafaxplus-${version}";
  version = "5.6.0";
  sha256 = "128514kw9kb5cvznm87z7gis1mpyx4bcqrxx4xa7cbfj1v3v81fr";

  configSite = substituteAll {
    name = "hylafaxplus-config.site";
    src = ./config.site;
    config_maxgid = lib.optionalString (maxgid!=null) ''CONFIG_MAXGID=${builtins.toString maxgid}'';
    ghostscript_version = ghostscript.version;
    out_ = "@out@";  # "out" will be resolved in post-install.sh
    inherit coreutils ghostscript libtiff;
  };

  postPatch = substituteAll {
    name = "hylafaxplus-post-patch.sh";
    src = ./post-patch.sh;
    inherit configSite;
    maxuid = lib.optionalString (maxuid!=null) (builtins.toString maxuid);
    faxcover_binpath = lib.makeBinPath
      [stdenv.shellPackage coreutils];
    faxsetup_binpath = lib.makeBinPath
      [stdenv.shellPackage coreutils findutils gnused gnugrep gawk];
  };

  postInstall = substituteAll {
    name = "hylafaxplus-post-install.sh";
    src = ./post-install.sh;
    inherit fakeroot libfaketime;
  };

in

stdenv.mkDerivation {
  inherit name version;
  src = fetchurl {
    url = "mirror://sourceforge/hylafax/hylafax-${version}.tar.gz";
    inherit sha256;
  };
  # Note that `configure` (and maybe `faxsetup`) are looking
  # for a couple of standard binaries in the `PATH` and
  # hardcode their absolute paths in the new package.
  buildInputs = [
    file  # for `file` command
    ghostscript
    libtiff
    psmisc  # for `fuser` command
    sharutils  # for `uuencode` command
    utillinux  # for `agetty` command
    zlib
    jbigkit  # optional
    lcms2  # optional
    openldap  # optional
    pam  # optional
  ];
  postPatch = ''. ${postPatch}'';
  dontAddPrefix = true;
  postInstall = ''. ${postInstall}'';
  postInstallCheck = ''. ${./post-install-check.sh}'';
  meta.description = "enterprise-class system for sending and receiving facsimiles";
  meta.homepage = http://hylafax.sourceforge.net;
  meta.license = lib.licenses.bsd3;
  meta.maintainers = [ lib.maintainers.yarny ];
  meta.platforms = lib.platforms.linux;
}
