{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "${pname}-${version}";
    sha256 = "05448p3bp01l5wyhl94023ywxxkmanm4gp4sdz1b71xicy2fnsmz";
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
