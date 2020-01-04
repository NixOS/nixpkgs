{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lr";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "1dxla14ldyym01lhmacfwps1vim0fk67c2ik2w08gg534siyj770";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/lr;
    description = "List files recursively";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ vika_nezrimaya ];
  };
}
