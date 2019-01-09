{ stdenv, fetchurl
, ed, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "patch-2.7.6";

  src = fetchurl {
    url = "mirror://gnu/patch/${name}.tar.xz";
    sha256 = "1zfqy4rdcy279vwn2z1kbv19dcfw25d2aqy9nzvdkq5bjzd0nqdc";
  };

  patches = [
    # https://git.savannah.gnu.org/cgit/patch.git/patch/?id=f290f48a621867084884bfff87f8093c15195e6a
    ./CVE-2018-6951.patch
    (fetchurl {
      url = https://sources.debian.org/data/main/p/patch/2.7.6-2/debian/patches/Allow_input_files_to_be_missing_for_ed-style_patches.patch;
      sha256 = "0iw0lk0yhnhvfjzal48ij6zdr92mgb84jq7fwryy1hdhi47hhq64";
    })
    (fetchurl { # CVE-2018-1000156
      url = https://sources.debian.org/data/main/p/patch/2.7.6-2/debian/patches/Fix_arbitrary_command_execution_in_ed-style_patches.patch;
      sha256 = "1bpy16n3hm5nv9xkrn6c4wglzsdzj3ss1biq16w9kfv48p4hx2vg";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_strnlen_working=yes"
  ];

  doCheck = stdenv.hostPlatform.libc != "musl"; # not cross;
  checkInputs = [ed];

  meta = {
    description = "GNU Patch, a program to apply differences to files";

    longDescription =
      '' GNU Patch takes a patch file containing a difference listing
         produced by the diff program and applies those differences to one or
         more original files, producing patched versions.
      '';

    homepage = https://savannah.gnu.org/projects/patch;

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
