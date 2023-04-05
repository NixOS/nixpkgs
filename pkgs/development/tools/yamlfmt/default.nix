{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yamlfmt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2gcB44tpYXRES0nqLfXt3Srj2NCuQ/iBdv4yxjfmrnk=";
  };

  vendorHash = "sha256-7Ip6dgpO3sPGXcwymYcaoFydTPIt+BmJC7UqyfltJx0=";

  doCheck = false;

  meta = with lib; {
    description = "An extensible command line tool or library to format yaml files.";
    homepage = "https://github.com/google/yamlfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sno2wman ];
  };
}
