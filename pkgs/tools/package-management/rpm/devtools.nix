{ autoreconfHook
, fetchgit
, gitMinimal
, help2man
, lib
, perl
, python3
, python3Packages
, rpm
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "rpmdevtools";
  version = "9.6";

  src = fetchgit {
    url = "https://pagure.io/rpmdevtools.git";
    rev = "refs/tags/RPMDEVTOOLS_${lib.concatStringsSep "_" (lib.versions.splitVersion version)}";
    hash = "sha256-MwqmBwnNSOhoTh+ZQIYdFdeDef969VSy2GShjINJS70=";
  };

  buildInputs = [
    autoreconfHook
    gitMinimal # rpmdev-packager seem to ask for it but not required
    help2man
    perl # for pod2man
    (python3.withPackages (p: with p; [ progressbar requests p.rpm ]))
    rpm
  ];

  preConfigure = ''
    substituteInPlace configure --replace 'PKG_CHECK_VAR(bashcompdir, bash-completion, completionsdir,
        HAVE_BASHCOMP2=1, bashcompdir="''${sysconfdir}/bash_completion.d")' 'HAVE_BASHCOMP2=0'
  '';

  preBuild = ''
    chmod u+x rpmdev-newinit.in rpmdev-newspec.in # for patchShebangs
    patchShebangs rpmdev-bumpspec rpmdev-spectool rpmdev-rmdevelrpms.py rpmdev-diff rpmdev-extract rpmdev-packager rpmdev-newinit.in rpmdev-newspec.in
  '';

  meta = with lib; {
    # metadata from https://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/r/rpmdevtools-9.6-3.fc38.noarch.html
    description = "RPM Development Tools";
    longDescription = ''
      This package contains scripts and (X)Emacs support files to aid in
      development of RPM packages.
      rpmdev-setuptree    Create RPM build tree within user's home directory
      rpmdev-diff         Diff contents of two archives
      rpmdev-newspec      Creates new .spec from template
      rpmdev-rmdevelrpms  Find (and optionally remove) "development" RPMs
      rpmdev-checksig     Check package signatures using alternate RPM keyring
      rpminfo             Print information about executables and libraries
      rpmdev-md5/sha*     Display checksums of all files in an archive file
      rpmdev-vercmp       RPM version comparison checker
      rpmdev-spectool     Expand and download sources and patches in specfiles
      rpmdev-wipetree     Erase all files within dirs created by rpmdev-setuptree
      rpmdev-extract      Extract various archives, "tar xvf" style
      rpmdev-bumpspec     Bump revision in specfile
      ...and many more.
      '';
    homepage = "https://fedoraproject.org/wiki/Rpmdevtools";
    downloadPage = "https://pagure.io/rpmdevtools/releases";
    changelog = "https://pagure.io/rpmdevtools/blob/main/f/NEWS";
    license = licenses.gpl2Only;
    maintainers = [];
    mainProgram = "rpmdev-setuptree"; # Most tutorials only explain this tools but it is used one time
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
}
