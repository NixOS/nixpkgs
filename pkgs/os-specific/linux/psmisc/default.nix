{stdenv, fetchFromGitLab, autoconf, automake, gettext, ncurses}:

stdenv.mkDerivation rec {
  pname = "psmisc";
  version = "23.2";
  name = "${pname}-${version}";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0d90wmibxpkl0d7sdibvvkwpyxyg6m6ksh5gwrjh15vf1swvd5i1";
  };

  nativeBuildInputs = [ autoconf automake gettext ];
  buildInputs = [ ncurses ];

  preConfigure = ''
    echo $version > .tarball-version
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/psmisc/psmisc;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ryantm ];
  };
}
