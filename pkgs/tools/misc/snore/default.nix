{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.2";
  pname = "snore";

  src = fetchFromGitHub {
    owner = "clamiax";
    repo = pname;
    rev = version;
    sha256 = "sha256-EOwbRqtQEuGZ+aeCBNVfLUq4m/bFWJTvMDM6a+y74qc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "sleep with feedback";
    homepage = "https://github.com/clamiax/snore";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
