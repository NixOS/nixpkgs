{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libcap }:

stdenv.mkDerivation rec {
  pname = "smcroute";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = version;
    sha256 = "sha256-I9kc1F+GZf8Gl0Wx3J45Bf/RyFTyHVhwDz5l+sp/2pc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libcap ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemd=\$(out)/lib/systemd/system"
  ];

  meta = with lib; {
    description = "Static multicast routing daemon";
    homepage = "https://troglobit.com/smcroute.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = with platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
}
