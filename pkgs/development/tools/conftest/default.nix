{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "15xdsjv53hjgmdxzdakj07ggickw1jkcii31ycb3q8nh1ki05rhq";
  };

  vendorSha256 = "0795npr09680nmxiz9riq5v6rp91qgkvw1lc2mn9gzakv1ywl5rq";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
