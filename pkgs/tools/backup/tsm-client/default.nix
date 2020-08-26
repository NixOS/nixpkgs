{ lib
, stdenv
, autoPatchelfHook
, buildEnv
, fetchurl
, makeWrapper
, procps
, zlib
# optional packages that enable certain features
, acl ? null  # EXT2/EXT3/XFS ACL support
, jdk8 ? null  # Java GUI
, lvm2 ? null  # LVM image backup and restore functions
# path to `dsm.sys` configuration files
, dsmSysCli ? "/etc/tsm-client/cli.dsm.sys"
, dsmSysApi ? "/etc/tsm-client/api.dsm.sys"
}:


# For an explanation of optional packages
# (features provided by them, version limits), see
# https://www-01.ibm.com/support/docview.wss?uid=swg21052223#Version%208.1


# IBM Tivoli Storage Manager Client uses a system-wide
# client system-options file `dsm.sys` and expects it
# to be located in a directory within the package.
# Note that the command line client and the API use
# different "dms.sys" files (located in different directories).
# Since these files contain settings to be altered by the
# admin user (e.g. TSM server name), we create symlinks
# in place of the files that the client attempts to open.
# Use the arguments `dsmSysCli` and `dsmSysApi` to
# provide the location of the configuration files for
# the command-line interface and the API, respectively.
#
# While the command-line interface contains wrappers
# that help the executables find the configuration file,
# packages that link against the API have to
# set the environment variable `DSMI_DIR` to
# point to this derivations `/dsmi_dir` directory symlink.
# Other environment variables might be necessary,
# depending on local configuration or usage; see:
# https://www.ibm.com/support/knowledgecenter/en/SSEQVQ_8.1.8/client/c_cfg_sapiunix.html


# The newest version of TSM client should be discoverable
# by going the the `downloadPage` (see `meta` below),
# there to "Client Latest Downloads",
# "IBM Spectrum Protect Client Downloads and READMEs",
# then to "Linux x86_64 Ubuntu client" (as of 2019-07-15).


let

  meta = {
    homepage = "https://www.ibm.com/us-en/marketplace/data-protection-and-recovery";
    downloadPage = "https://www-01.ibm.com/support/docview.wss?uid=swg21239415";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.yarny ];
    description = "IBM Spectrum Protect (Tivoli Storage Manager) CLI and API";
    longDescription = ''
      IBM Spectrum Protect (Tivoli Storage Manager) provides
      a single point of control for backup and recovery.
      This package contains the client software, that is,
      a command line client and linkable libraries.

      Note that the software requires a system-wide
      client system-options file (commonly named "dsm.sys").
      This package allows to use separate files for
      the command-line interface and for the linkable API.
      The location of those files can
      be provided as build parameters.
    '';
  };

  unwrapped = stdenv.mkDerivation rec {
    name = "tsm-client-${version}-unwrapped";
    version = "8.1.8.0";
    src = fetchurl {
      url = "ftp://public.dhe.ibm.com/storage/tivoli-storage-management/maintenance/client/v8r1/Linux/LinuxX86_DEB/BA/v818/${version}-TIV-TSMBAC-LinuxX86_DEB.tar";
      sha256 = "0c1d0jm0i7qjd314nhj2vj8fs7sncm1x2n4d6dg4049jniyvjhpk";
    };
    inherit meta;

    nativeBuildInputs = [
      autoPatchelfHook
    ];
    buildInputs = [
      stdenv.cc.cc
      zlib
    ];
    runtimeDependencies = [
      lvm2
    ];
    sourceRoot = ".";

    postUnpack = ''
      for debfile in *.deb
      do
        ar -x "$debfile"
        tar --xz --extract --file=data.tar.xz
        rm data.tar.xz
      done
    '';

    installPhase = ''
      runHook preInstall
      mkdir --parents $out
      mv --target-directory=$out usr/* opt
      runHook postInstall
    '';

    # Fix relative symlinks after `/usr` was moved up one level
    preFixup = ''
      for link in $out/lib/* $out/bin/*
      do
        target=$(readlink "$link")
        if [ "$(cut -b -6 <<< "$target")" != "../../" ]
        then
          echo "cannot fix this symlink: $link -> $target"
          exit 1
        fi
        ln --symbolic --force --no-target-directory "$out/$(cut -b 7- <<< "$target")" "$link"
      done
    '';
  };

in

buildEnv {
  name = "tsm-client-${unwrapped.version}";
  inherit meta;
  passthru = { inherit unwrapped; };
  paths = [ unwrapped ];
  buildInputs = [ makeWrapper ];
  pathsToLink = [
    "/"
    "/bin"
    "/opt/tivoli/tsm/client/ba/bin"
    "/opt/tivoli/tsm/client/api/bin64"
  ];
  # * Provide top-level symlinks `dsm_dir` and `dsmi_dir`
  #   to the so-called "installation directories"
  # * Add symlinks to the "installation directories"
  #   that point to the `dsm.sys` configuration files
  # * Drop the Java GUI executable unless `jdk` is present
  # * Create wrappers for the command-line interface to
  #   prepare `PATH` and `DSM_DIR` environment variables
  postBuild = ''
    ln --symbolic --no-target-directory opt/tivoli/tsm/client/ba/bin $out/dsm_dir
    ln --symbolic --no-target-directory opt/tivoli/tsm/client/api/bin64 $out/dsmi_dir
    ln --symbolic --no-target-directory "${dsmSysCli}" $out/dsm_dir/dsm.sys
    ln --symbolic --no-target-directory "${dsmSysApi}" $out/dsmi_dir/dsm.sys
    ${lib.strings.optionalString (jdk8==null) "rm $out/bin/dsmj"}
    for bin in $out/bin/*
    do
      target=$(readlink "$bin")
      rm "$bin"
      makeWrapper "$target" "$bin" \
        --prefix PATH : "$out/dsm_dir:${lib.strings.makeBinPath [ procps acl jdk8 ]}" \
        --set DSM_DIR $out/dsm_dir
    done
  '';
}
