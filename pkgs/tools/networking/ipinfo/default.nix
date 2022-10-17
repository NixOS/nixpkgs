{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "${pname}-${version}";
    hash = "sha256-oim234254qUWITfgBfB2theMgpVnGHNmrzwE5ULM2M4=";
  };

  vendorSha256 = null;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
