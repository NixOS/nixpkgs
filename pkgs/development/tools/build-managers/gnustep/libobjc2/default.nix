{stdenv, fetchFromGitHub, gobjc, cmake}:

stdenv.mkDerivation rec {
  name = "libobjc2-${version}";
  version = "1.8.1";
  src = fetchFromGitHub {
    repo = "libobjc2";
    owner = "gnustep";
    rev = "v${version}";
    sha256 = "12v9pjg97h56mb114cqd22q1pdwhmxrgdw5hal74ddlrhiq1nzvi";
  };
  buildInputs = [gobjc cmake];
}
