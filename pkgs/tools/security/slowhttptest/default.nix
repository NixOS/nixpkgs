{ lib
, stdenv
, fetchFromGitHub
, openssl
}:

stdenv.mkDerivation rec {
  pname = "slowhttptest";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "shekyan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xv2j3hl4zj0s2cxcsvlwgridh9ap4g84g7c4918d03id15wydcx";
  };

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Application Layer DoS attack simulator";
    homepage = "https://github.com/shekyan/slowhttptest";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
