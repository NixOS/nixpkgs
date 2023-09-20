{ lib
, stdenv
, fetchFromGitLab
, autoconf
, automake
, gettext
, ncurses
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
