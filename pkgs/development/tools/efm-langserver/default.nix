{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.46";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-mGcpV4PDD6HJZH+3Lybsds4xPJS5rkOouKqKX7j+7WA=";
  };

  vendorHash = "sha256-KABezphT5/o3XWSFNe2OvfawFR8uwsGMnjsI9xh378Q=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
