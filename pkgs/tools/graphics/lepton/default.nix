{ stdenv, fetchFromGitHub, cmake, git, glibc }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "lepton-${version}";

  src = fetchFromGitHub {
    repo = "lepton";
    owner = "dropbox";
    rev = "c378cbfa2daaa99e8828be7395013f94cedb1bcc";
    sha256 = "1f2vyp0crj4yw27bs53vykf2fqk4w57gv3lh9dp89dh3y7wwh1ba";
  };

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ glibc.static ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dropbox/lepton;
    description = "A tool to losslessly compress JPEGs";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ artemist ];
  };
}
