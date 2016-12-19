{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, file , protobufc }:

stdenv.mkDerivation rec {
  name = "riemann-c-client-${version}";

  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "algernon";
    repo = "riemann-c-client";
    rev = "54f4a656793d6c5ca0bf1ff2388693fb6b2b82a7";
    sha256 = "0jc2bbw7sp2gr4cswx78srs0p1kp81prcarq4ivqpfw4bmzg6xg4";
  };

  buildInputs = [ autoreconfHook pkgconfig file protobufc ];

  meta = with stdenv.lib; {
    homepage = https://github.com/algernon/riemann-c-client;
    description = "A C client library for the Riemann monitoring system";
    license = licenses.gpl3;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
