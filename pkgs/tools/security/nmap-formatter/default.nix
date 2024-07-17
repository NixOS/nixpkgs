{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nmap-formatter";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-40ix4D/f63Q5cqVmBvpSmbK2KNXiYLdv/xXBNPJXfac=";
  };

  vendorHash = "sha256-OUhvQwC7EJF7CIM7NHCs0TqRTZHTiDupkfYREPaxpXo=";

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    mainProgram = "nmap-formatter";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
