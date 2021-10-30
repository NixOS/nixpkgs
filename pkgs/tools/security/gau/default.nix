{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gau";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hUIUDDP9NtMmJXj5GCD/ISUUcx5prKCVVFztff9txoU=";
  };

  vendorSha256 = "sha256-WMoFbqtBMcjTWX51mEMzpgDEAndCElldNqjG27yXd2w=";

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
