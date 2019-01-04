{ stdenv, fetchFromGitHub, getdns, libtool, m4, file , doxygen
, autoreconfHook, automake, check, libbsd, libyaml, darwin }:

stdenv.mkDerivation rec {
  pname = "stubby";
  name = "${pname}-${version}";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "getdnsapi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c0jqbxcrwc8kvpx7v0bmdladf20myyi2672r2r87m2q0jvsmgpr";
  };

  nativeBuildInputs = [ libtool m4 libbsd libyaml autoreconfHook ];

  buildInputs = [ doxygen getdns automake file check ]
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
    homepage = https://dnsprivacy.org/wiki/x/JYAT;
    downloadPage = "https://github.com/getdnsapi/stubby";
    maintainers = with maintainers; [ leenaars ];
    license = licenses.bsd3; platforms = platforms.all;
    };
}
