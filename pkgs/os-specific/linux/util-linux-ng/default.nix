{ stdenv, fetchurl, ncurses ? null

, # Util-linux-ng requires libuuid and libblkid.
  e2fsprogs

, # Build mount/umount only.
  buildMountOnly ? false
  
, # A directory containing mount helpers programs
  # (i.e. `mount.<fstype>') to be used instead of /sbin.
  mountHelpers ? null
}:

stdenv.mkDerivation {
  name = (if buildMountOnly then "mount-" else "") + "util-linux-ng-2.14.1";

  src = fetchurl {
    url = mirror://kernel/linux/utils/util-linux-ng/v2.14/util-linux-ng-2.14.1.tar.bz2;
    sha256 = "0b40xwdqpp16fcy1vfzqigl41d9slq32kzv2jr6nfy5bk59rqa5z";
  };

  configureFlags = ''
    --disable-use-tty-group
    ${if ncurses == null then "--without-ncurses" else ""}
  '';

  buildInputs = [e2fsprogs]
    ++ stdenv.lib.optional (ncurses != null) ncurses;

  inherit mountHelpers;

  preConfigure = ''
    makeFlagsArray=(usrbinexecdir=$out/bin usrsbinexecdir=$out/sbin datadir=$out/share exampledir=$out/share/getopt)
    if test -n "$mountHelpers"; then
      substituteInPlace mount/mount.c --replace /sbin/mount. $mountHelpers/mount.
      substituteInPlace mount/umount.c --replace /sbin/umount. $mountHelpers/umount.
    fi
  '';

  buildPhase =
    if buildMountOnly then ''
      make "''${makeFlagsArray[@]}" -C lib
      make "''${makeFlagsArray[@]}" -C mount
    '' else "";

  installPhase =
    if buildMountOnly then ''
      make "''${makeFlagsArray[@]}" -C lib install
      make "''${makeFlagsArray[@]}" -C mount install
    '' else "";

  # Hack to get static builds to work.
  NIX_CFLAGS_COMPILE = "-DHAVE___PROGNAME=1"; 
}
