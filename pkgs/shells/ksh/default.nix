{ stdenv, meson, ninja, fetchFromGitHub, which, python }:

stdenv.mkDerivation rec {
  name = "ksh-${version}";
  version = "93v";

  src = fetchFromGitHub {
    owner  = "att";
    repo   = "ast";
    rev    = "b8d88244ae87857e7bbd6da230ffbbc51165df70";
    sha256 = "12kf14n8vz36hnsy3wp6lnyv1841p7hcq25y1d78w532dil69lx9";
  };

  nativeBuildInputs = [ meson ninja which python ];

  meta = with stdenv.lib; {
    description = "KornShell Command And Programming Language";
    longDescription = ''
      The KornShell language was designed and developed by David G. Korn at
      AT&T Bell Laboratories. It is an interactive command language that
      provides access to the UNIX system and to many other systems, on the
      many different computers and workstations on which it is implemented. 
    '';
    homepage = https://github.com/att/ast;
    license = licenses.cpl10;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/ksh";
  };
}

