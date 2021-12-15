{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "log4j-vuln-scanner";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "hillu";
    repo = "local-log4j-vuln-scanner";
    rev = "v${version}";
    sha256 = "sha256-6LbKwDu3YZFRaIUOcepbLVZC9OYnqb0Tl0ElGDIzW48=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    description = "Local log4j vulnerability scanner";
    homepage = "https://github.com/hillu/local-log4j-vuln-scanner";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
