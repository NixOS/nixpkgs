{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gau";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "lc";
    repo = "gau";
    rev = "refs/tags/v${version}";
    hash = "sha256-1sF33uat6nwtTaXbZzO8YF4jewyQJ6HvI2l/zyTrJsg=";
  };

  vendorHash = "sha256-nhsGhuX5AJMHg+zQUt1G1TwVgMCxnuJ2T3uBrx7bJNs=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool to fetch known URLs";
    longDescription = ''
      getallurls (gau) fetches known URLs from various sources for any
      given domain.
    '';
    homepage = "https://github.com/lc/gau";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gau";
  };
}
