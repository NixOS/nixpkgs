{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2023.1.3";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-ZgPRUkvokHwMHWQMjQJ3Uprt+lf2CAv1kmpUI93J0Cs=";
  };

  vendorHash = "sha256-o9UtS6AMgRYuAkOWdktG2Kr3QDBDQTOGSlya69K2br8=";

  excludedPackages = [ "website" ];

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit smasher164 ];
  };
}
