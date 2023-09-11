{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "5.0.9310";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gwaNz4OgYs5mAMi/HtLOXoIJA/iHPKX+eiVBP2l2YFU=";
  };

  vendorHash = "sha256-PClKzvpztpry8xsYLfWB/9s/qI5k2m8qHBxkxY0AJqI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya kashw2 ];
  };
}
