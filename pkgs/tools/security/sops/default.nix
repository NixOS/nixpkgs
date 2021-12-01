{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.7.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "0z3jcyl245yjszzjf2h6l1dwa092vxzvfmnivmwi6jvpsdcv33h1";
  };

  vendorSha256 = "1mnwgsbpi56ql0lbpn7dkaps96x9b1lmhlk5cd6d40da7xj616n7";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    changelog = "https://github.com/mozilla/sops/raw/v${version}/CHANGELOG.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
