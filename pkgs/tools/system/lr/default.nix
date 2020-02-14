{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lr";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "lr";
    rev = "v${version}";
    sha256 = "1wv2acm4r5y5gg6f64v2hiwpg1f3lnr4fy1a9zssw77fmdc7ys3j";
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
