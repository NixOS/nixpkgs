{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aviator";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "herrjulz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Oa4z8n+q7LKWMnwk+xj9UunzOa3ChaPBCTo828yYJGQ=";
  };

  patches = [
    ./bump-golang-x-sys.patch
  ];

  deleteVendor = true;
  vendorHash = "sha256-AJyxCE4DdAXRS+2sY4Zzu8NTEFKJoV1bopfOqOFKZfI=";

  meta = with lib; {
    description = "Merge YAML/JSON files in a in a convenient fashion";
    homepage = "https://github.com/herrjulz/aviator";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
