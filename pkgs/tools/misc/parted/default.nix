{ stdenv
, fetchurl
, fetchpatch
, lvm2
, libuuid
, gettext
, readline
, dosfstools
, e2fsprogs
, perl
, python2
, utillinux
, check
, enableStatic ? false
}:

stdenv.mkDerivation rec {
  name = "parted-3.3";

  src = fetchurl {
    url = "mirror://gnu/parted/${name}.tar.xz";
    sha256 = "0i1xp367wpqw75b20c3jnism3dg3yqj4a7a22p2jb1h1hyyv9qjp";
  };

  outputs = [ "out" "dev" "man" "info" ];

  postPatch = ''
    patchShebangs tests
  '';

  buildInputs = [ libuuid ]
    ++ stdenv.lib.optional (readline != null) readline
    ++ stdenv.lib.optional (gettext != null) gettext
    ++ stdenv.lib.optional (lvm2 != null) lvm2;

  configureFlags =
       (if (readline != null)
        then [ "--with-readline" ]
        else [ "--without-readline" ])
    ++ stdenv.lib.optional (lvm2 == null) "--disable-device-mapper"
    ++ stdenv.lib.optional enableStatic "--enable-static";

  # Tests were previously failing due to Hydra running builds as uid 0.
  # That should hopefully be fixed now.
  doCheck = !stdenv.hostPlatform.isMusl; /* translation test */
  checkInputs = [ check dosfstools e2fsprogs perl python2 utillinux ];

  meta = {
    description = "Create, destroy, resize, check, and copy partitions";

    longDescription = ''
      GNU Parted is an industrial-strength package for creating, destroying,
      resizing, checking and copying partitions, and the file systems on
      them.  This is useful for creating space for new operating systems,
      reorganising disk usage, copying data on hard disks and disk imaging.

      It contains a library, libparted, and a command-line frontend, parted,
      which also serves as a sample implementation and script backend.
    '';

    homepage = https://www.gnu.org/software/parted/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [
      # Add your name here!
    ];

    # GNU Parted requires libuuid, which is part of util-linux-ng.
    platforms = stdenv.lib.platforms.linux;
  };
}
