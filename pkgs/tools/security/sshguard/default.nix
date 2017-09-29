{ stdenv, fetchurl, autoreconfHook, yacc, flex}:


stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "sshguard-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sshguard/sshguard-2.0.0.tar.gz";
    sha256 = "e87c6c4a6dddf06f440ea76464eb6197869c0293f0a60ffa51f8a6a0d7b0cb06";
  };

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook yacc flex ];

  configureFlags = [ "--sysconfdir=/etc" ];

  patches = [ ./0001-Remove-the-unnecessary-from-ipset-cmds.patch ];

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
