{ lib, stdenv, fetchFromGitHub, curl, perl }:

stdenv.mkDerivation rec {
  pname = "trurl";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "curl";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-z7Na7lXDzSmBTuSBaizyG892D3IfbN43ytPjOEQ9CAA=";
  };

  separateDebugInfo = stdenv.isLinux;

  enableParallelBuilding = true;

  buildInputs = [ curl ];
  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;
  checkInputs = [ perl ];
  checkTarget = "test";

  meta = with lib; {
    description = "A command line tool for URL parsing and manipulation";
    homepage = "https://curl.se/trurl";
    changelog = "https://github.com/curl/trurl/releases/tag/${pname}-${version}";
    license = licenses.curl;
    maintainers = with maintainers; [ christoph-heiss ];
    platforms = platforms.all;
  };
}
