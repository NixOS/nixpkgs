{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libcap }:

stdenv.mkDerivation rec {
  pname = "smcroute";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = version;
    sha256 = "sha256-0s4BIJbbygt7Wpxlp13QGbXpvZsdIBszE7TOaN2aq/E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libcap ];

  configureFlags =
    [ "--localstatedir=/var" "--with-systemd=$(out)/lib/systemd/system" ];

  meta = with lib; {
    description = "Static multicast routing daemon";
    homepage = "https://troglobit.com/smcroute.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
}
