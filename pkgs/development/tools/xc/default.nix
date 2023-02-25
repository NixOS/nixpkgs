{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.0.159";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5Vw/UStMtP5CHbSCOzeD4LMJccPG34Rxw9VHc9Ut3oM=";
  };

  vendorHash = "sha256-XDJdCh6P8ScSvxY55ExKgkgFQqmBaM9fMAjAioEQ0+s=";

  meta = with lib; {
    homepage = "https://xcfile.dev/";
    description = "Markdown defined task runner";
    license = licenses.mit;
    maintainers = with maintainers; [ joerdav ];
  };
}
