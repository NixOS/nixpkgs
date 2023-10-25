{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oshka";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fpWhqFK5h/U7DCC/SyhAlMyCMhjZHRLMlwakvlhOd3w=";
  };

  vendorSha256 = "sha256-ZBI3WDXfJKBEF2rmUN3LvOOPT1185dHmj88qJKsdUiE=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/k1LoW/oshka/version.Version=${version}"
  ];

  # Tests requires a running Docker instance
  doCheck = false;

  meta = with lib; {
    description = "Tool for extracting nested CI/CD supply chains and executing commands";
    homepage = "https://github.com/k1LoW/oshka";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
