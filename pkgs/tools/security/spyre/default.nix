{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, yara
}:

buildGoModule rec {
  pname = "spyre";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "spyre-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-408UOY7kvukMYOVqQfpugk6Z+LNQV9XyfJirKyBRWd4=";
  };

  vendorSha256 = "sha256-qZkt5WwicDXrExwMT0tCO+FZgClIHhrVtMR8xNsdAaQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    yara
  ];

  meta = with lib; {
    description = "YARA-based IOC scanner";
    homepage = "https://github.com/spyre-project/spyre";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
