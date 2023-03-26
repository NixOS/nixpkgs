{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "passphrase2pgp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-it1XYzLiteL0oq4SZp5E3s6oSkFKi3ZY0Lt+P0gmNag=";
  };

  vendorSha256 = "sha256-2H9YRVCaari47ppSkcQYg/P4Dzb4k5PLjKAtfp39NR8=";

  postInstall = ''
    mkdir -p $out/share/doc/$name
    cp README.md $out/share/doc/$name
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Predictable, passphrase-based PGP key generator";
    homepage = "https://github.com/skeeto/passphrase2pgp";
    license = licenses.unlicense;
    maintainers = with maintainers; [ kaction ];
  };
}
