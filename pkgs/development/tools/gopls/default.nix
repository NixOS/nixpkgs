{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-VBan3IKqf3AFrPoryT/U7lGabFHSXMhaBpnNw3LRH/I=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-pW4G89fYFwVM2EkIqTCsl2lhN677LIMFpKPvLVV2boY=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 SuperSandro2000 zimbatm ];
  };
}
