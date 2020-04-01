{ stdenv, fetchFromGitHub, getdns, doxygen, libyaml, darwin, cmake, systemd }:

stdenv.mkDerivation rec {
  pname = "stubby";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "getdnsapi";
    repo = pname;
    rev = "v${version}";
    sha256 = "04izd1v4fv9l7r75aafkrp6svczbx4cvv1vnfyx5n9105pin11mx";
  };

  nativeBuildInputs = [ cmake libyaml ];

  buildInputs = [ doxygen getdns systemd ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with stdenv.lib; {
    description = "A local DNS Privacy stub resolver (using DNS-over-TLS)";
    longDescription = ''
      Stubby is an application that acts as a local DNS Privacy stub
      resolver (using RFC 7858, aka DNS-over-TLS). Stubby encrypts DNS
      queries sent from a client machine (desktop or laptop) to a DNS
      Privacy resolver increasing end user privacy. Stubby is developed by
      the getdns team.
    '';
    homepage = "https://dnsprivacy.org/wiki/x/JYAT";
    downloadPage = "https://github.com/getdnsapi/stubby";
    maintainers = with maintainers; [ leenaars ehmry ];
    license = licenses.bsd3; platforms = platforms.all;
  };
}
