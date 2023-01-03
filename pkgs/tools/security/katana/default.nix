{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "katana";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8OpBxv++AjKNitHqB6y8hN8LlkFBvyzooJZPWhHd28w=";
  };

  vendorSha256 = "sha256-jc8OcImVOmN/iYbcYQJ9Z2cYaNAVVdn9nKWBSuyh2HQ=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/katana" ];

  meta = with lib; {
    description = "A next-generation crawling and spidering framework";
    homepage = "https://github.com/projectdiscovery/katana";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
