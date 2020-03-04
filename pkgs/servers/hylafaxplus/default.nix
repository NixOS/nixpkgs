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
  version = "7.0.2";
  sha256 = "17vym1gz5ppy3q6zbw2y4nkq1dspn31k12zcmva44fnw9diwvsfb";

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
  meta = {
    description = "enterprise-class system for sending and receiving facsimiles";
    downloadPage = https://hylafax.sourceforge.io/download.php;
    homepage = https://hylafax.sourceforge.io;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.yarny ];
    platforms = lib.platforms.linux;
    longDescription = ''
      HylaFAX is a scalable and time-proven solution
      for sending and receiving facsimiles via modem(s).
      It is based on a client-server architecture,
      loosely comparable to CUPS:
      A client connects to a server to issue outbound jobs,
      the server then chooses a modem to
      connect to the receiving fax machine.
      The server notifies users about their
      outbound jobs as well as about inbound jobs.
      HylaFAX+ is a fork of HylaFAX that -- in general --
      contains a superset of the features of
      HylaFAX and produces releases more often.
      This package contains the client
      and the server parts of HylaFAX+.
    '';
  };
}
