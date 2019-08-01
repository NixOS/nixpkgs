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
      url = https://git.savannah.gnu.org/cgit/patch.git/patch/?id=b5a91a01e5d0897facdd0f49d64b76b0f02b43e1;
      sha256 = "0iw0lk0yhnhvfjzal48ij6zdr92mgb84jq7fwryy1hdhi47hhq64";
    })
    (fetchurl { # CVE-2018-1000156
      url = https://git.savannah.gnu.org/cgit/patch.git/patch/?id=123eaff0d5d1aebe128295959435b9ca5909c26d;
      sha256 = "1bpy16n3hm5nv9xkrn6c4wglzsdzj3ss1biq16w9kfv48p4hx2vg";
    })
    # https://git.savannah.gnu.org/cgit/patch.git/commit/?id=9c986353e420ead6e706262bf204d6e03322c300
    ./CVE-2018-6952.patch
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
