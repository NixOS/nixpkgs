{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "passphrase2pgp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ik/W3gGvrOyUvYgMYqT8FIFoxp62BXd2GpV14pYXEuY=";
  };

  vendorSha256 = "sha256-2H9YRVCaari47ppSkcQYg/P4Dzb4k5PLjKAtfp39NR8=";

  postInstall = ''
    mkdir -p $out/share/doc/$name
    cp README.md $out/share/doc/$name
  '';

  meta = with lib; {
    description = "Predictable, passphrase-based PGP key generator";
    homepage = "https://github.com/skeeto/passphrase2pgp";
    license = licenses.unlicense;
    maintainers = with maintainers; [ kaction ];
  };
}
