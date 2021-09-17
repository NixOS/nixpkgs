{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XG/nci8Sj0vfa/SFPpJwl1Zmt/23LfKxocejplZtS0E=";
  };

  vendorSha256 = "sha256-WR1CpjEMHRkpd0/iqrOm0oVXvyQO+r6GyeP0L0zx8aA=";

  doCheck = false;

  ldflags = [
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
