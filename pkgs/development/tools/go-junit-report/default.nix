{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-junit-report";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jstemmer";
    repo = "go-junit-report";
    rev = "v${version}";
    sha256 = "sha256-/ER99EmYrERBjcJeYeV3GBq6lDjACM0loICg41hUuPQ=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Convert go test output to junit xml";
    homepage = "https://github.com/jstemmer/go-junit-report";
    license = licenses.mit;
    maintainers = with maintainers; [ cryptix ];
  };
}
