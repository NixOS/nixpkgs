{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "xe";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "xe";
    rev = "v${version}";
    sha256 = "04jr8f6jcijr0bsmn8ajm0aj35qh9my3xjsaq64h8lwg5bpyn29x";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple xargs and apply replacement";
    homepage = https://github.com/chneukirchen/xe;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan ];
  };
}
