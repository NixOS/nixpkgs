{stdenv, fetchurl, fuse, bison, flex_2_5_35, openssl, python3, ncurses, readline,
 autoconf, automake, libtool, pkgconfig, zlib, libaio, libxml2, acl, sqlite,
 liburcu, attr, makeWrapper, coreutils, gnused, gnugrep, which,
 openssh, gawk, findutils, utillinux, lvm2, btrfs-progs, e2fsprogs, xfsprogs, systemd,
 rsync, glibc
}:
let
  s =
  rec {
    baseName="glusterfs";
    # NOTE: On each glusterfs release, it should be checked if gluster added
    #       new, or changed, Python scripts whose PYTHONPATH has to be set in
    #       `postFixup` below, and whose runtime deps need to go into
    #       `nativeBuildInputs`.
    #       The command
    #         find /nix/store/...-glusterfs-.../ -name '*.py' -executable
    #       can help with finding new Python scripts.
    version = "6.5";
    name="${baseName}-${version}";
    url="https://github.com/gluster/glusterfs/archive/v${version}.tar.gz";
    sha256 = "17vdrw71ys1n5g9pdmzipmr706bslq0gbxxjhacxnrgsz8r4rl6a";
  };

  buildInputs = [
    fuse bison flex_2_5_35 openssl ncurses readline
    autoconf automake libtool pkgconfig zlib libaio libxml2
    acl sqlite liburcu attr makeWrapper utillinux
    (python3.withPackages (pkgs: [
      pkgs.flask
      pkgs.prettytable
      pkgs.requests
      pkgs.pyxattr
    ]))
    # NOTE: `python3` has to be *AFTER* the above `python3.withPackages`,
    #       to ensure that the packages are available but the `toPythonPath`
    #       shell function used in `postFixup` is also still available.
    python3
  ];
  # Some of the headers reference acl
  propagatedBuildInputs = [
    acl
  ];
  # Packages from which GlusterFS calls binaries at run-time from PATH,
  # with comments on which commands are known to be called by it.
  runtimePATHdeps = [
    attr # getfattr setfattr
    btrfs-progs # btrfs
    coreutils # lots of commands in bash scripts
    e2fsprogs # tune2fs
    findutils # find
    gawk # awk
    glibc # getent
    gnugrep # grep
    gnused # sed
    lvm2 # lvs
    openssh # ssh
    rsync # rsync, e.g. for geo-replication
    systemd # systemctl
    utillinux # mount umount
    which # which
    xfsprogs # xfs_info
  ];
in
stdenv.mkDerivation
{
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;

  patches = [
    # Remove when https://bugzilla.redhat.com/show_bug.cgi?id=1489610 is fixed
    ./glusterfs-fix-bug-1489610-glusterfind-var-data-under-prefix.patch
  ];

  postPatch = ''
    sed -e '/chmod u+s/d' -i contrib/fuse-util/Makefile.am
  '';

   # Note that the VERSION file is something that is present in release tarballs
   # but not in git tags (at least not as of writing in v3.10.1).
   # That's why we have to create it.
   # Without this, gluster (at least 3.10.1) will fail very late and cryptically,
   # for example when setting up geo-replication, with a message like
   #   Staging of operation 'Volume Geo-replication Create' failed on localhost : Unable to fetch master volume details. Please check the master cluster and master volume.
   # What happens here is that the gverify.sh script tries to compare the versions,
   # but fails when the version is empty.
   # See upstream GlusterFS bug https://bugzilla.redhat.com/show_bug.cgi?id=1452705
   preConfigure = ''
     echo "v${s.version}" > VERSION
    ./autogen.sh
    export PYTHON=${python3}/bin/python
    '';

  configureFlags = [
    ''--localstatedir=/var''
    ];

  makeFlags = "DESTDIR=$(out)";

  enableParallelBuilding = true;

  postInstall = ''
    cp -r $out/$out/* $out
    rm -r $out/nix
    '';

  postFixup = ''
    # glusterd invokes `gluster` and other utilities when telling other glusterd nodes to run commands.
    # For example for `peer_georep-sshkey` key generation, so `$out/bin` is needed in the PATH.
    # It also invokes bash scripts like `gverify.sh`.
    # It also invokes executable Python scripts in `$out/libexec/glusterfs`, which is why we set up PYTHONPATH accordingly.
    # We set up the paths for the main entry point executables.

    GLUSTER_PATH="${stdenv.lib.makeBinPath runtimePATHdeps}:$out/bin"
    GLUSTER_PYTHONPATH="$(toPythonPath $out):$out/libexec/glusterfs"
    GLUSTER_LD_LIBRARY_PATH="$out/lib"

    wrapProgram $out/bin/glusterd --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/gluster --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/sbin/mount.glusterfs --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"

    # Set Python environment for the Python based utilities.
    # It would be nice if there was a better way to do this, automatically for all of them.
    # Also, this is brittle: If we forget a dependency or gluster adds a new one, things will break deep inside gluster.
    # We should better try to get an explicit list of Python dependencies from gluster and ensure all of them are in the PYTHONPATH of all these python scripts.
    # But at the time of writing (gluster 3.10), gluster only provides this in form of a gluster.spec file for RPM creation,
    # and even that one is not complete (for example it doesn't mention the `flask` dependency).

    wrapProgram $out/bin/gluster-eventsapi --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/gluster-georep-sshkey --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/gluster-mountbroker --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/bin/glusterfind --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"

    # Note that we only wrap the symlinks in $out/bin, not the actual executable scripts in $out/libexec/glusterfs.
    # This is because those scripts use `__file__` in their program logic
    # (see https://github.com/gluster/glusterfs/blob/v3.10.1/extras/cliutils/cliutils.py#L116)
    # which would break if we changed the file name (which is what `wrapProgram` does).
    # Luckily, `libexec` scripts are never supposed to be invoked straight from PATH,
    # instead they are invoked directly from `gluster` or `glusterd`, which is why it is
    # sufficient to set PYTHONPATH for those executables.
    #
    # Exceptions to these rules are the `glusterfind` `brickfind.py` and `changelog.py`
    # crawlers, which are directly invoked on other gluster nodes using a remote SSH command
    # issues by `glusterfind`.

    wrapProgram $out/share/glusterfs/scripts/eventsdash.py --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/libexec/glusterfs/glusterfind/brickfind.py --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    wrapProgram $out/libexec/glusterfs/glusterfind/changelog.py --set PATH "$GLUSTER_PATH" --set PYTHONPATH "$GLUSTER_PYTHONPATH" --set LD_LIBRARY_PATH "$GLUSTER_LD_LIBRARY_PATH"
    '';

  doInstallCheck = true;

  # Below we run Python programs. That generates .pyc/.pyo files.
  # By default they are indeterministic because such files contain time stamps
  # (see https://nedbatchelder.com/blog/200804/the_structure_of_pyc_files.html).
  # So we use the same environment variables as in
  #   https://github.com/NixOS/nixpkgs/blob/249b34aadca7038207492f29142a3456d0cecec3/pkgs/development/interpreters/python/mk-python-derivation.nix#L61
  # to make these files deterministic.
  # A general solution to this problem might be brought by #25707.
  DETERMINISTIC_BUILD = 1;
  PYTHONHASHSEED = 0;

  installCheckPhase = ''
    # Tests that the above programs work without import errors.
    # For testing it manually in a shell you may want to substitute `$out` with `$(dirname $(readlink -f $(which gluster)))/../`.
    $out/bin/glusterd --help
    # $out/bin/gluster help # can't do this because even `gluster help` tries to write to `/var/log/glusterfs/cli.log`
    $out/bin/gluster-eventsapi --help
    $out/bin/gluster-georep-sshkey --help
    $out/bin/gluster-mountbroker --help
    $out/bin/glusterfind --help
    # gfid_to_path.py doesn't accept --help, and it requires different arguments
    # (a dir as single argument) than the usage prints when stdin is not a TTY.
    # The `echo ""` is just so that stdin is not a TTY even if you try this line
    # on a real TTY for testing purposes.
    echo "" | (mkdir -p nix-test-dir-for-gfid_to_path && touch b && $out/libexec/glusterfs/gfind_missing_files/gfid_to_path.py nix-test-dir-for-gfid_to_path)
    $out/share/glusterfs/scripts/eventsdash.py --help

    # this gets falsely loaded as module by glusterfind
    rm -r $out/bin/conf.py
    '';

  src = fetchurl {
    inherit (s) url sha256;
  };

  meta = with stdenv.lib; {
    inherit (s) version;
    description = "Distributed storage system";
    homepage = https://www.gluster.org;
    license = licenses.lgpl3Plus; # dual licese: choice of lgpl3Plus or gpl2
    maintainers = [ maintainers.raskin ];
    platforms = with platforms; linux ++ freebsd;
  };
}
