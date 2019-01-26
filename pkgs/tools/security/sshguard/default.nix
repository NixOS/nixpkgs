{ stdenv, fetchurl, autoreconfHook, yacc, flex}:

stdenv.mkDerivation rec {
  version = "2.3.1";
  name = "sshguard-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/${name}.tar.gz";
    sha256 = "18i0kmjvym9xym3ysg5kap0298nzcprar9y96k54p3zpdpi5b43n";
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
