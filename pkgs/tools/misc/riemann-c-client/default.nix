{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file , protobufc }:

stdenv.mkDerivation rec {
  pname = "riemann-c-client";
  version = "1.9.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "${name}";
    sha256 = "1j3wgf9xigsv6ckmv82gjj4wavi7xjn2zvj1f63fzbaa1rv7pf3s";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ file protobufc ];

  meta = with stdenv.lib; {
    homepage = https://github.com/algernon/riemann-c-client;
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rickynils pradeepchhetri ];
    platforms = platforms.linux;
  };
}
