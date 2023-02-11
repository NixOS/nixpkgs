{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2023.1";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-RzYaaiDu78JVM8G0zJzlZcyCd+1V9KZIyIIyVib0yZc=";
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
