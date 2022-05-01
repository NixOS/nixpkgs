{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.14.2";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-9n/Ozyy1QzjFum/R/X2DChzTHl70e+JQuo09nToAIcE=";
  };

  vendorSha256 = "/fN9nRYOy00EeI8zZQFkCgTMGLZ0pFbYmRdTr2NLIsc=";

  subPackages = [ "cmd/ooniprobe" ];

  meta = with lib; {
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
