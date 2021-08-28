{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
  version = "0.3.18";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
    sha256 = "0534jyravpsj73lgdmw6fns1qaqiw401jlfk04wa0as5sv09rfhy";
  };

  vendorSha256 = null;

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "A tool to list and diagnose Go processes currently running on your system";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
