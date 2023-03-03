{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aviator";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "herrjulz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jqAGwPqxxCkBpSMebikdUGh54hlSLeqAyf7BOBtjiNA=";
  };

  deleteVendor = true;
  vendorHash = "sha256-rYOphvI1ZE8X5UExfgxHnWBn697SDkNnmxeY7ihIZ1s=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Merge YAML/JSON files in a in a convenient fashion";
    homepage = "https://github.com/herrjulz/aviator";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
