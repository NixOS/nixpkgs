{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.7.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "sha256-NMuYMvaBSxKHvpqFkMfnMDvcXxTstqzracuSTT1VB1A=";
  };

  vendorSha256 = "sha256-00/7O9EcGojUExJPtYWndb16VqrNby/5GsVs8Ak/Isc=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    changelog = "https://github.com/mozilla/sops/raw/v${version}/CHANGELOG.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
