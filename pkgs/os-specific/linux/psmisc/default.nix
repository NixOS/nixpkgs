{lib, stdenv, fetchFromGitLab, fetchpatch, autoconf, automake, gettext, ncurses}:

stdenv.mkDerivation rec {
  pname = "psmisc";
  version = "23.5";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-02jvRPqN8DS30ID42hQFu400NoFC5QiH5YA3NB+EoFI=";
  };

  patches = [
    # Upstream patch to be released in the next version
    (fetchpatch {
      name = "fallback-to-kill.diff";
      url = "https://gitlab.com/psmisc/psmisc/-/commit/6892e321e7042e3df60a5501a1c59d076e8a856f.patch";
      sha256 = "sha256-3uk1KXEOqAxpHWBORUw5+dR5s/Z55JJs5tuBZlTdjlo=";
      excludes = [ "ChangeLog" ];
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
