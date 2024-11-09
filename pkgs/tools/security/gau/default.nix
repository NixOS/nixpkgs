{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gau";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "lc";
    repo = "gau";
    rev = "refs/tags/v${version}";
    hash = "sha256-B2l5joHeFDjYmdb3F1FFDKjIKENZu92O2sMlkf3Sf6Y=";
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
