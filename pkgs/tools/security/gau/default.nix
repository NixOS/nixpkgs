{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gau";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GkPAv6JrgzlblSw4oIvPvNSboOmvZCMKyFwAMD3W0fQ=";
  };

  vendorSha256 = "sha256-u5ketxHPwZN2mV0uTgwJbY+ImusGZ9GTTmFAGvdH5yA=";

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
