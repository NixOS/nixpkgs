{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gokart";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oxYlwc3FatYyaICQFZJtkH9/7zYfT2gI+R5BU7CQVkg=";
  };

  vendorSha256 = "sha256-lgKYVgJlmUJ/msdIqG7EKAZuISie1lG7+VeCF/rcSlE=";

  # Would need files to scan which are not shipped by the project
  doCheck = false;

  meta = with lib; {
    description = "Static analysis tool for securing Go code";
    homepage = "https://github.com/praetorian-inc/gokart";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
