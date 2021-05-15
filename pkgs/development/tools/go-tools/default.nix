{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.2.4";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "sha256-yFZ01bfejbq8zQ52DbcomBcHnB6H5Ds4MJP93xQ2/jU=";
  };

  vendorSha256 = "sha256-Uw36Jn9RGcVIyzDOMIwi6hMQsSDWKG0kYpOOpREANyA=";

  doCheck = false;

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
