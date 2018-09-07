{ stdenv, fetchurl, autoreconfHook, yacc, flex}:

stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "sshguard-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/${name}.tar.gz";
    sha256 = "1hjn6smd6kc3yg2xm1kvszqpm5w9a6vic6a1spzy8czcwvz0gzra";
  };

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook yacc flex ];

  configureFlags = [ "--sysconfdir=/etc" ];

  meta = with stdenv.lib; {
    description = "SSHGuard protects hosts from brute-force attacks";
    longDescription = ''
      SSHGuard can read log messages from various input sources. Log messages are parsed, line-by-line, for recognized patterns.
      If an attack, such as several login failures within a few seconds, is detected, the offending IP is blocked.
    '';
    homepage = https://sshguard.net;
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux ++ darwin ++ freebsd ++ netbsd ++ openbsd;
  };
}
