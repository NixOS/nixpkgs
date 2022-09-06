{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "2.10.2400";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bqd91m7m4i4lfvz4p1lbrfs01kyh73p0g236q13bv4x1n1lkqr3";
  };

  vendorSha256 = "sha256-hLz36ESf6To6sT/ha/yXyhG0U1gGw8HDfnrPJnws25g=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya ];
  };
}
