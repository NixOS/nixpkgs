{ lib, stdenv, fetchFromGitHub, util-linux, libgee, libsoup, json-glib, desktop-file-utils, vte, rsync, vala, dpkg, diffutils, coreutils, which, pkg-config, psmisc}:

stdenv.mkDerivation rec {
  pname = "timeshift";
  version = "21.09.1";

  src = fetchFromGitHub {
    owner = "teejee2008";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z55dw3sd2cil9akms3m7wd70pijys5cgj39hsrkcrzz1ql9pcn7";
  };

  postPatch = ''
    substituteInPlace src/makefile --replace "prefix=/usr" "prefix=$out"
    substituteInPlace src/makefile --replace "sysconfdir=/etc" "sysconfdir=$out/etc"
    substituteInPlace src/Core/Main.vala --replace "/sbin/blkid" "${util-linux}/bin/blkid"
    substituteInPlace src/Core/Main.vala --replace "fuser" "${psmisc}/bin/fuser"
  '';

  buildInputs = [ libgee libsoup json-glib desktop-file-utils vte rsync ];
  nativeBuildInputs = [ vala dpkg diffutils coreutils which pkg-config ];
  propagatedBuildInputs = [ psmisc rsync which ];

  meta = with lib; {
    description = "System snapshot tool for Linux.";
    homepage    = "https://github.com/teejee2008/timeshift";
    license     = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [  ];
    platforms   = platforms.linux;
  };
}
