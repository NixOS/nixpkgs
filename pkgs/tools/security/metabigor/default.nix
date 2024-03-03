{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "metabigor";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JFt9PC6VHWTYuaIWh2t2BiGFm1tGwZDdhhdp2xtmXSI=";
  };

  vendorHash = "sha256-PGUOTEFcOL1pG+itTp9ce1qW+1V6hts8jKpA0E8orDk=";

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = with lib; {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
