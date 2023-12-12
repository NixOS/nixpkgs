{ lib
, stdenv
, fetchFromGitLab
, autoconf
, automake
, gettext
, ncurses
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "psmisc";
  version = "23.6";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TjnOn8a7HAgt11zcM0i5DM5ERmsvLJHvo1e5FOsl6IA=";
  };

  patches = [
    # Upstream patches to be released in the next version
    (fetchpatch {
      name = "fallback-to-stat-on-enosys.diff";
      url = "https://gitlab.com/psmisc/psmisc/-/commit/c22d1e4edbfec6e24346cd8d89b822cb07cd6f5c.patch";
      sha256 = "sha256-X6oEsxNgbywfeucSkhMSq6fVrfWmCg67bF11pUBc2zU=";
      excludes = [ "ChangeLog" ];
    })
    (fetchpatch {
      name = "fallback-to-stat-on-einval.diff";
      url = "https://gitlab.com/psmisc/psmisc/-/commit/d681ce822066cb474b491c691b54fa901d08c002.patch";
      sha256 = "sha256-m6NaKWdRz0XupMxm2m67kZnkEslSFZpqeCdhZU1lNgk=";
    })
  ];

  nativeBuildInputs = [ autoconf automake gettext ];
  buildInputs = [ ncurses ];

  preConfigure = lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    # Goes past the rpl_malloc linking failure
    export ac_cv_func_malloc_0_nonnull=yes
    export ac_cv_func_realloc_0_nonnull=yes
  '' + ''
    echo $version > .tarball-version
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/psmisc/psmisc";
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ryantm ];
  };
}
