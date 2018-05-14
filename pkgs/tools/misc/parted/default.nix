{ stdenv, fetchurl, fetchpatch, devicemapper, libuuid, gettext, readline, perl, python2
, utillinux, check, enableStatic ? false, hurd ? null }:

stdenv.mkDerivation rec {
  name = "parted-3.2";

  src = fetchurl {
    url = "mirror://gnu/parted/${name}.tar.xz";
    sha256 = "1r3qpg3bhz37mgvp9chsaa3k0csby3vayfvz8ggsqz194af5i2w5";
  };

  patches = stdenv.lib.optional doCheck ./gpt-unicode-test-fix.patch
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/parted/fix-includes.patch?id=9c5cd3c329a40ba4559cc1d8c7d17a9bf95c237b";
      sha256 = "117ypyiwvzym6pi8xmy16wa5z3sbpx7gh6haabs6kfb1x2894z7q";
    });

  postPatch = stdenv.lib.optionalString doCheck ''
    patchShebangs tests
  '';

  buildInputs = [ libuuid ]
    ++ stdenv.lib.optional (readline != null) readline
    ++ stdenv.lib.optional (gettext != null) gettext
    ++ stdenv.lib.optional (devicemapper != null) devicemapper
    ++ stdenv.lib.optional (hurd != null) hurd
    ++ stdenv.lib.optionals doCheck [ check perl python2 ];

  configureFlags =
       (if (readline != null)
        then [ "--with-readline" ]
        else [ "--without-readline" ])
    ++ stdenv.lib.optional (devicemapper == null) "--disable-device-mapper"
    ++ stdenv.lib.optional enableStatic "--enable-static";

  # Tests were previously failing due to Hydra running builds as uid 0.
  # That should hopefully be fixed now.
  doCheck = !stdenv.hostPlatform.isMusl; /* translation test */

  preCheck =
    stdenv.lib.optionalString doCheck
      # The `t0400-loop-clobber-infloop.sh' test wants `mkswap'.
      "export PATH=\"${utillinux}/sbin:$PATH\"";

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

    homepage = http://www.gnu.org/software/parted/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [
      # Add your name here!
    ];

    # GNU Parted requires libuuid, which is part of util-linux-ng.
    platforms = stdenv.lib.platforms.linux;
  };
}
