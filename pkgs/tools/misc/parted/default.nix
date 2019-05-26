{ stdenv, fetchurl, fetchpatch, lvm2, libuuid, gettext, readline, perl, python2
, utillinux, check, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "parted-3.2";

  src = fetchurl {
    url = "mirror://gnu/parted/${name}.tar.xz";
    sha256 = "1r3qpg3bhz37mgvp9chsaa3k0csby3vayfvz8ggsqz194af5i2w5";
  };

  outputs = [ "out" "dev" "man" "info" ];

  patches = stdenv.lib.optional doCheck ./gpt-unicode-test-fix.patch
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/parted/fix-includes.patch?id=9c5cd3c329a40ba4559cc1d8c7d17a9bf95c237b";
      sha256 = "117ypyiwvzym6pi8xmy16wa5z3sbpx7gh6haabs6kfb1x2894z7q";
    })
    ++ stdenv.lib.optional (lvm2 == null)
    (fetchpatch {
      url = https://git.savannah.gnu.org/cgit/parted.git/patch/?id=7e87ca3c531228d35e13e802d2622006138b104c;
      sha256 = "0i29lfg8cwj342q5s7qwqhncz2bkifj5rjc7cx6jd4zqb6ykkndj";
    });

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

  checkInputs = [ check perl python2 utillinux ];

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
