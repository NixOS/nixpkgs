{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gau";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1sF33uat6nwtTaXbZzO8YF4jewyQJ6HvI2l/zyTrJsg=";
  };

  vendorHash = "sha256-nhsGhuX5AJMHg+zQUt1G1TwVgMCxnuJ2T3uBrx7bJNs=";

  meta = with lib; {
    description = "Tool to fetch known URLs";
    mainProgram = "gau";
    longDescription = ''
      getallurls (gau) fetches known URLs from various sources for any
      given domain.
    '';
    homepage = "https://github.com/lc/gau";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
