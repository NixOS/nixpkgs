{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "geek1011";
    repo = pname;
    rev = "v${version}";
    sha256 = "13d3fl53v9pqlm555ly1dm9vc58xwkyik0qmsg173q78ysy2p4q5";
  };

  modSha256 = "0jz8v4rnwm5zbxxp49kv96wm4lack6prwyhcrqwsrm79dr9yjcxf";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
