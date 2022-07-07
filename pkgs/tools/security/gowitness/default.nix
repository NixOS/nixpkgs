{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gowitness";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    hash = "sha256-6O4pGsUu9tG3VAIGaD9aauXaVMhvK+HpEjByE0AwVnE=";
  };

  vendorSha256 = "sha256-6FgYDiz050ZlC1XBz7dKkVFKY7gkGhIm0ND23tMwxC8=";

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
