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
, libxcrypt
, openssl
, psmisc
, sharutils
, util-linux
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

  pname = "hylafaxplus";
  version = "7.0.6";
  hash = "sha512-0faeEwF/XQE/85zwUMOnrGzvGanuWRDr53SnrgbX0i/SHjHelzSEd2TK6plVOfV4w8RY7Ox7lSO1gjqEEzfZyw==";

  configSite = substituteAll {
    name = "${pname}-config.site";
    src = ./config.site;
    config_maxgid = lib.optionalString (maxgid!=null) ''CONFIG_MAXGID=${builtins.toString maxgid}'';
    ghostscript_version = ghostscript.version;
    out_ = "@out@";  # "out" will be resolved in post-install.sh
    inherit coreutils ghostscript libtiff;
  };

  postPatch = substituteAll {
    name = "${pname}-post-patch.sh";
    src = ./post-patch.sh;
    inherit configSite;
    maxuid = lib.optionalString (maxuid!=null) (builtins.toString maxuid);
    faxcover_binpath = lib.makeBinPath
      [stdenv.shellPackage coreutils];
    faxsetup_binpath = lib.makeBinPath
      [stdenv.shellPackage coreutils findutils gnused gnugrep gawk];
  };

  postInstall = substituteAll {
    name = "${pname}-post-install.sh";
    src = ./post-install.sh;
    inherit fakeroot libfaketime;
  };

in

stdenv.mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "mirror://sourceforge/hylafax/hylafax-${version}.tar.gz";
    inherit hash;
  };
  patches = [
    # adjust configure check to work with libtiff > 4.1
    ./libtiff-4.patch
    # fix missing exports in libtiff 4.5+
    # https://gitlab.com/libtiff/libtiff/-/issues/504
    # can probably be dropped with next hylafaxplus release
    (fetchurl {
      name = "hylafaxplus-7.0.6-tiff-4.5.0.patch";
      url = "https://dev.gentoo.org/~sam/distfiles/net-misc/hylafaxplus/hylafaxplus-7.0.6-tiff-4.5.0.patch.xz";
      downloadToTemp = true;
      postFetch = ''xz -d < $downloadedFile > $out'';
      hash = "sha256-koZvvzlgZHcANVaYdewnuLARz2TTeyDZRjm0EYWzsmk=";
    })
  ];
  # Note that `configure` (and maybe `faxsetup`) are looking
  # for a couple of standard binaries in the `PATH` and
  # hardcode their absolute paths in the new package.
  buildInputs = [
    file  # for `file` command
    ghostscript
    libtiff
    libxcrypt
    openssl
    psmisc  # for `fuser` command
    sharutils  # for `uuencode` command
    util-linux  # for `agetty` command
    zlib
    jbigkit  # optional
    lcms2  # optional
    openldap  # optional
    pam  # optional
  ];
  # Disable parallel build, errors:
  #  *** No rule to make target '../util/libfaxutil.so.7.0.4', needed by 'faxmsg'.  Stop.
  enableParallelBuilding = false;

  postPatch = ". ${postPatch}";
  dontAddPrefix = true;
  postInstall = ". ${postInstall}";
  postInstallCheck = ". ${./post-install-check.sh}";
  meta = {
    changelog = "https://hylafax.sourceforge.io/news/${version}.php";
    description = "enterprise-class system for sending and receiving facsimiles";
    downloadPage = "https://hylafax.sourceforge.io/download.php";
    homepage = "https://hylafax.sourceforge.io";
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
