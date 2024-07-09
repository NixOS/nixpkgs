{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2XbqpvtlNAYrgtaMnFklYRoHCj3nkltEZlwbZzvfdFU=";
  };

  vendorHash = "sha256-PKoe4rpwPy3omfRRhN70iEJJ/sHliIwxPUHGxRJqrf4=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
