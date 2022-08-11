{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tK9jPImB3rklMVQGI84bFaWsEdmVZKnWXxfzLZL9jQU=";
  };

  vendorSha256 = "sha256-w90f5b70qc9mgfMkhhloLJ7UWXboOLcZD6kUBluGGfk=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
