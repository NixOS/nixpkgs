{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
  version = "0.46.1";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U0jHwKmGHpaHSiOYDeYCXiufw0JjzAmhBnINmFsqOJo=";
  };

  vendorHash = "sha256-9/z1mtZGqrvcvq8cWBpYN7kaPHaPqtyMwMNxuRRP4Cs=";

  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
