{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "ion";
  version = "unstable-2021-05-10";

  src = fetchFromGitHub {
    owner = "redox-os";
    repo = "ion";
    rev = "1170b84587bbad260a3ecac8e249a216cb1fd5e9";
    sha256 = "sha256-lI1GwA3XerRJaC/Z8vTZc6GzRDLjv3w768C+Ui6Q+3Q=";
  };

  cargoSha256 = "sha256-hURpgxc99iIMtzIlR6Kbfqcbu1uYLDHnfVLqgmMbvFA=";

  meta = with lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = "https://gitlab.redox-os.org/redox-os/ion";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
    libiconv
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    shellPath = "/bin/ion";
  };
}
