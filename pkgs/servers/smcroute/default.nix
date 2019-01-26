{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libcap }:

stdenv.mkDerivation rec {
  name = "smcroute-${version}";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = version;
    sha256 = "1bdz3dic12lwl3rfczd9bxpgjbpw2g7yap2zddz6dvgkqvyjjf1h";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libcap ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemd=\$(out)/lib/systemd/system"
  ];

  meta = with stdenv.lib; {
    description = "Static multicast routing daemon";
    homepage = http://troglobit.com/smcroute.html;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
}
