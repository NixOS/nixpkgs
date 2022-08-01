{lib, stdenv, fetchFromGitLab, autoconf, automake, gettext, ncurses}:

stdenv.mkDerivation rec {
  pname = "psmisc";
  version = "23.5";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-02jvRPqN8DS30ID42hQFu400NoFC5QiH5YA3NB+EoFI=";
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
