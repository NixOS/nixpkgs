{ lib, stdenv, fetchFromGitHub, gnulib, perl, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "lbzip2";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "kjn";
    repo = "lbzip2";
    rev = "v${version}";
    sha256 = "1h321wva6fp6khz6x0i6rqb76xh327nw6v5jhgjpcckwdarj5jv8";
  };

  buildInputs = [ gnulib perl ];
  nativeBuildInputs = [ autoconf automake ];

  preConfigure = ''
    substituteInPlace configure.ac --replace 'AC_PREREQ([2.63])' 'AC_PREREQ(2.64)'
    ./build-aux/autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/kjn/lbzip2"; # Formerly http://lbzip2.org/
    description = "Parallel bzip2 compression utility";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
