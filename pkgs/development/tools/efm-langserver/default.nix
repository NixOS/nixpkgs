{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.44";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-+yN08MAoFaixvt2EexhRNucG6I4v2FdHf44XlYIwzhA=";
  };

  vendorSha256 = "sha256-KABezphT5/o3XWSFNe2OvfawFR8uwsGMnjsI9xh378Q=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
