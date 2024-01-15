{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "impl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${version}";
    hash = "sha256-BqRoLh0MpNQgY9OHHRBbegWGsq3Y4wOqg94rWvex76I=";
  };

  vendorHash = "sha256-+5+CM5iGV54zRa7rJoQDBWrO98icNxlAv8JwATynanY=";

  preCheck = ''
    export GOROOT="$(go env GOROOT)"
  '';

  meta = with lib; {
    description = "Generate method stubs for implementing an interface";
    homepage = "https://github.com/josharian/impl";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
