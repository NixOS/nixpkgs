{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "geek1011";
    repo = pname;
    rev = "v${version}";
    sha256 = "13vl8jn1kp0v84963kcl8j98gmm5a1i16ccd9i19in968875w4wl";
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
