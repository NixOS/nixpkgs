{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "lr-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "0g4iqz8ddv7dsrfhx0828bmc16ff8qp8xh5ya9f0n5qj4zh4cn35";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.globin ];
  };
}
