{ stdenv, lib, fetchFromGitHub, fetchurl, autoreconfHook, openssl, readline }:

stdenv.mkDerivation rec {
  pname = "ipmitool";
  version = "1.8.19";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "IPMITOOL_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-VVYvuldRIHhaIUibed9cLX8Avfy760fdBLNO8MoUKCk=";
  };

  # IANA list of enterprise numbers
  # Public domain, see: https://www.iana.org/help/licensing-terms
  enterprise_numbers = fetchurl {
    url = "https://www.iana.org/assignments/enterprise-numbers.txt";
    hash = "sha256-aA7FPF3kLDDzeq7lc3n1dnLBaPKY6sdZXf5B7A6/ArI=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl readline ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'AC_MSG_WARN([** Neither wget nor curl could be found.])' 'AM_CONDITIONAL([DOWNLOAD], [false])'
  '';

  # Install the IANA enterprise numbers
  postInstall = ''
    install -D ${enterprise_numbers} $out/share/misc/enterprise-numbers
  '';

  meta = with lib; {
    description = "Command-line interface to IPMI-enabled devices";
    license = licenses.bsd3;
    homepage = "https://github.com/ipmitool/ipmitool";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
