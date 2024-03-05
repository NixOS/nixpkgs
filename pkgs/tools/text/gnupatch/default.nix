{ lib, stdenv, fetchurl
, ed, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "patch";
  version = "2.7.6";

  src = fetchurl {
    url = "mirror://gnu/patch/patch-${version}.tar.xz";
    sha256 = "1zfqy4rdcy279vwn2z1kbv19dcfw25d2aqy9nzvdkq5bjzd0nqdc";
  };

  patches = [
    # https://git.savannah.gnu.org/cgit/patch.git/patch/?id=f290f48a621867084884bfff87f8093c15195e6a
    ./CVE-2018-6951.patch

    # https://git.savannah.gnu.org/cgit/patch.git/patch/?id=b5a91a01e5d0897facdd0f49d64b76b0f02b43e1
    ./Allow_input_files_to_be_missing_for_ed-style_patches.patch

    # https://git.savannah.gnu.org/cgit/patch.git/patch/?id=123eaff0d5d1aebe128295959435b9ca5909c26d
    ./CVE-2018-1000156.patch

    # https://git.savannah.gnu.org/cgit/patch.git/commit/?id=9c986353e420ead6e706262bf204d6e03322c300
    ./CVE-2018-6952.patch

    # https://git.savannah.gnu.org/cgit/patch.git/patch/?id=dce4683cbbe107a95f1f0d45fabc304acfb5d71a
    ./CVE-2019-13636.patch

    # https://git.savannah.gnu.org/cgit/patch.git/patch/?id=3fcd042d26d70856e826a42b5f93dc4854d80bf0
    ./CVE-2019-13638-and-CVE-2018-20969.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_strnlen_working=yes"
  ];

  doCheck = stdenv.hostPlatform.libc != "musl"; # not cross;
  nativeCheckInputs = [ed];

  meta = {
    description = "GNU Patch, a program to apply differences to files";

    longDescription =
      '' GNU Patch takes a patch file containing a difference listing
         produced by the diff program and applies those differences to one or
         more original files, producing patched versions.
      '';

    homepage = "https://savannah.gnu.org/projects/patch";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
