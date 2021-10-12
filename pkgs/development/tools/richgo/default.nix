{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "sha256-yVt0iFH9tYCeIWJC16ve988xBXgt96357YiHfsxai7g=";
  };

  vendorSha256 = "sha256-IJjJ4X3mv2PUmwzt5/hgv1N6R0w+EXGSrCS4q+INJrA=";

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Enrich `go test` outputs with text decorations";
    homepage = "https://github.com/kyoh86/richgo";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
