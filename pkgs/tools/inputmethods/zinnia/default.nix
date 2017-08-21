{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "zinnia-${version}";
  version = "2015-03-15";

  src = fetchFromGitHub {
    owner = "taku910";
    repo = "zinnia";
    rev = "d8de1180d5175d7579e6c41b000f1ab4dd9cd697";
    sha256 = "ac09a16c04c5ef9b46626984e627250dc717d85711d14f1bbfa7f1ca0ca713dc";
  };

  setSourceRoot = "export sourceRoot=$(echo zinnia-*/zinnia/)";

  meta = with stdenv.lib; {
    description = "Online hand recognition system with machine learning";
    homepage = http://taku910.github.io/zinnia/;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
