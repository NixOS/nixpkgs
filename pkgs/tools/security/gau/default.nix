{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gau";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AtKakeQnxRbFAbK/aQ4OQoEowN753jm4P4M57Oo3x1Y=";
  };

  vendorHash = "sha256-nhsGhuX5AJMHg+zQUt1G1TwVgMCxnuJ2T3uBrx7bJNs=";

  meta = with lib; {
    description = "Tool to fetch known URLs";
    longDescription = ''
      getallurls (gau) fetches known URLs from various sources for any
      given domain.
    '';
    homepage = "https://github.com/lc/gau";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
