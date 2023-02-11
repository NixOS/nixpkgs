{ stdenv, lib, fetchFromGitHub, autoreconfHook, openssl, readline }:

stdenv.mkDerivation rec {
  pname = "ipmitool";
  version = "1.8.19";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "IPMITOOL_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-VVYvuldRIHhaIUibed9cLX8Avfy760fdBLNO8MoUKCk=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl readline ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'AC_MSG_WARN([** Neither wget nor curl could be found.])' 'AM_CONDITIONAL([DOWNLOAD], [false])'
  '';

  meta = with lib; {
    description = "Command-line interface to IPMI-enabled devices";
    license = licenses.bsd3;
    homepage = "https://github.com/ipmitool/ipmitool";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
