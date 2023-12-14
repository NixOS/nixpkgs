{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-M0IV7pgJyCxwfWRnJeMevFFsvaXTRfjXoGRsMngt7Pk=";
  };

  vendorHash = "sha256-Wx07tSHr5LKPdO3BQ3tGMxzxYP9jBnH3JQ8/yrvwX1U=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
