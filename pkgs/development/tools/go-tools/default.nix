{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2022.1.2";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-pfZv/GZxb7weD+JFGCOknhRCsx8g5puQfpY9lZ4v6Rs=";
  };

  vendorSha256 = "sha256-19uLCtKuuZoVwC4SUKvYGWi2ryqAQbcKXY1iNjIqyn8=";

  excludedPackages = [ "website" ];

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit smasher164 ];
  };
}
