{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "impl";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "josharian";
    repo = "impl";
    rev = "v${version}";
    sha256 = "sha256-OztQR1NusP7/FTm5kmuSSi1AC47DJFki7vVlPQIl6+8=";
  };

  vendorSha256 = "sha256-+5+CM5iGV54zRa7rJoQDBWrO98icNxlAv8JwATynanY=";

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
