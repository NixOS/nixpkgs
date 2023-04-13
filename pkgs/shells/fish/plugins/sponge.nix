{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "sponge";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "meaningful-ooo";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
  };

  meta = with lib; {
    description = "keeps your fish shell history clean from typos, incorrectly used commands and everything you don't want to store due to privacy reasons";
    homepage = "https://github.com/meaningful-ooo/sponge";
    license = licenses.mit;
    maintainers = with maintainers; [ quantenzitrone ];
  };
}
