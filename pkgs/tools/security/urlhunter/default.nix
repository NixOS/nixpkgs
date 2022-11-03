{ buildGoModule
, fetchFromGitHub
, lib
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "urlhunter";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "utkusen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lX5zh+fYVSyWPUOnfRNMGZPsiuxjKBSpluPUMN9mZ+k=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-z1i+rdAt72p+4IuoHdL77ZhFjOBP84gnNsFvkRuO91w=";

  meta = with lib; {
    description = "Recon tool that allows searching shortened URLs";
    longDescription = ''
      urlhunter is a recon tool that allows searching on URLs that are
      exposed via shortener services such as bit.ly and goo.gl.
    '';
    homepage = "https://github.com/utkusen/urlhunter";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
