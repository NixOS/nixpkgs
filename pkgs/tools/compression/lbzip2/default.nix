{ stdenv, fetchFromGitHub, perl, gnulib, autoconf, automake }:

stdenv.mkDerivation rec {
  pname = "lbzip2";
  version = "2.5+git20180127";

  src = fetchFromGitHub {
    owner = "kjn";
    repo = "lbzip2";
    rev = "b6dc48a7b9bfe6b340ed1f6d72133608ad57144b";
    sha256 = "140xp00dmjsr6c3dwb4dwf0pzlgf159igri321inbinsjiclkngy";
  };

  preConfigure = ''
    substituteInPlace build-aux/autogen.sh --replace gnulib-tool 'gnulib-tool --symlink --more-symlink'
    build-aux/autogen.sh
  '';

  nativeBuildInputs = [ perl gnulib autoconf automake ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/kjn/lbzip2"; # Formerly http://lbzip2.org/
    description = "Parallel bzip2 compression utility";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
