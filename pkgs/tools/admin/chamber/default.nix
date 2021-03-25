{ buildGoModule, lib, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "chamber";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "eOMY9P/fCYvnl6KGNb6wohykLA0Sj9Ti0L18gx5dqUk=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/segmentio/chamber/commit/3aeb416cdf4c232552b653262e37047fc13b1f02.patch";
      sha256 = "cyxNF9ZP4oG+1sfX9yWZCyntpAvwYUh5BzTirZQGejc=";
    })
  ];

  vendorSha256 = null;

  # set the version. see: chamber's Makefile
  buildFlagsArray = ''
    -ldflags=
    -X main.Version=v${version}
  '';

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
