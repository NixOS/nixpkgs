{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "4.1.1100";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Yiyx25pAB0ETMSCkWXQ3vtDqfxZpKvPT4B/y2URnWoA=";
  };

  vendorHash = "sha256-9ENLuVlecZen+A/aywe8JK055yEy5D406+eYXmJyE3I=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dit7ya ];
  };
}
