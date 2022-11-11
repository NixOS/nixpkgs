{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "f2";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
    sha256 = "sha256-bNcPzvjVBH7x60kNjlUILiQGG3GDmqIB5T2WP3+nZ+s=";
  };

  vendorSha256 = "sha256-Cahqk+7jDMUtZq0zhBll1Tfryu2zSPBN7JKscV38360=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
