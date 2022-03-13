{ lib, fetchFromGitHub, buildGoModule, testVersion, clash }:

buildGoModule rec {
  pname = "clash";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cAJjW+NzG48HcDRx12LLdj8VYyIroL+GWqrUrpHOOIk=";
  };

  vendorSha256 = "sha256-hE2MgjaVme+4vG7+rmJXfjycd3N2R6cA5iSUUTFcQXE=";

  postPatch = ''
    # Do not build testing suit
    rm -rf ./test
  '';

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  passthru.tests.version = testVersion {
    package = clash;
    command = "clash -v";
  };

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ contrun Br1ght0ne ];
  };
}
