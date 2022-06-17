{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dalfox";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MCKXhDhpFLZTf0CYS3W4+4FykTuBu7q3Dy+R7RNp11s=";
  };

  vendorSha256 = "sha256-GW2DgfHEKKWBfW5A7DYqhV2jP3FLDjzpYOMWSTNCN0Q=";

  meta = with lib; {
    description = "Tool for analysing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
