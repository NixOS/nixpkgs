{ stdenv, fetchurl, autoreconfHook, yacc, flex}:

stdenv.mkDerivation rec {
  version = "2.4.0";
  pname = "sshguard";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/${pname}-${version}.tar.gz";
    sha256 = "1h6n2xyh58bshplbdqlr9rbnf3lz7nydnq5m2hkq15is3c4s8p06";
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
    homepage = "https://sshguard.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sargon ];
    platforms = with platforms; linux ++ darwin ++ freebsd ++ netbsd ++ openbsd;
  };
}
