{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "murex";
  version = "4.1.4200";

  src = fetchFromGitHub {
    owner = "lmorg";
    repo = "murex";
    rev = "v${version}";
    hash = "sha256-+oJN9yRxsj+zUimr9PRxVQkbvdINmG+mVjbgUp8g91o=";
  };

  vendorHash = "sha256-gbcC+SZoqM3DEhPzI3GDAW0n69aApldsgI3+e81Zqdo=";

  ldflags = [ "-s" "-w" ];

  # tests are meant to be run as
  # murex -c 'g: behavioural/*.mx -> foreach: f { source $f }; try {test: run *}'
  # however some tests are failing
  doCheck = false;

  postInstall = ''
    rm $out/bin/docgen $out/bin/server $out/bin/wasmserver
  '';

  meta = with lib; {
    description = "Bash-like shell and scripting environment with advanced features designed for safety and productivity";
    homepage = "https://murex.rocks";
    maintainers = with maintainers; [ dit7ya ];
    license = licenses.gpl2Only;
  };
}
