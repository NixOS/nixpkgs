{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomodifytags";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "gomodifytags";
    rev = "v${version}";
    sha256 = "1yhkn9mdvsn9i5v03c5smz32zlhkylnxhkcbjb7llafxzbhzgfm6";
  };

  vendorSha256 = "sha256-8efqJfu+gtoFbhdlDZfb8NsXV9hBDI2pvAQNH18VVhU=";

  meta = {
    description = "Go tool to modify struct field tags";
    homepage = "https://github.com/fatih/gomodifytags";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.bsd3;
  };
}
