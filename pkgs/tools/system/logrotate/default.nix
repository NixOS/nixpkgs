{ lib, stdenv, fetchFromGitHub, gzip, popt, autoreconfHook
, mailutils ? null
}:

stdenv.mkDerivation rec {
  pname = "logrotate";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    rev = version;
    sha256 = "133k4y24p918v4dva6dh70bdfv13jvwl2vlhq0mybrs3ripvnh4h";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  configureFlags = [
    "--with-compress-command=${gzip}/bin/gzip"
    "--with-uncompress-command=${gzip}/bin/gunzip"
  ] ++ lib.optionals (mailutils != null) [
    "--with-default-mail-command=${mailutils}/bin/mail"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ];

  meta = with lib; {
    homepage = "https://fedorahosted.org/releases/l/o/logrotate/";
    description = "Rotates and compresses system logs";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.viric ];
    platforms = platforms.all;
  };
}
