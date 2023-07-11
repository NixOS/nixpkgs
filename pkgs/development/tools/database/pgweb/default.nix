{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pgweb";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NPuL7ffDLpnu0khJBIz+tItYyeHYPeOuTHXr4DjBgM0=";
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

  vendorSha256 = "sha256-W+Vybea4oppD4BHRqcyouQL79cF+y+sONY9MRggti20=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A web-based database browser for PostgreSQL";
    longDescription = ''
      A simple postgres browser that runs as a web server. You can view data,
      run queries and examine tables and indexes.
    '';
    homepage = "https://sosedoff.github.io/pgweb/";
    license = licenses.mit;
    maintainers = with maintainers; [ zupo luisnquin ];
  };
}
