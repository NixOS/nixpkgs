{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "sha256-ehhrJlB0XzLHkspvP6vL8MtrjE12baBFkbqWMD41/Sg=";
  };

  vendorSha256 = "sha256-986Abeeb1MHB/0yN1oud6t8wHD5B5MisRHKZcwOq4tU=";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Enrich `go test` outputs with text decorations";
    homepage = "https://github.com/kyoh86/richgo";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
