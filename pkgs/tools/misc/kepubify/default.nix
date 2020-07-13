{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "geek1011";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fd7w9cmdca6ivppmpn5bkqxmz50xgihrm2pbz6h8jf92i485md0";
  };

  vendorSha256 = "1gzlxdbmrqqnrjx83g65yn7n93w13ci4vr3mpywasxfad866gc24";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}