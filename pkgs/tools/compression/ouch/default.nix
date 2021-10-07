{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-OhEr/HvwgDkB8h3cpayOlnrs6OXiwAsQUH9XGqi5rpc=";
  };

  cargoSha256 = "sha256-lKsB75Lb9IYS80qu4jaIpnbEOr4Ow9M5S45Kk03An2o=";

  meta = with lib; {
    description = "A command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    license = licenses.mit;
    maintainers = [ maintainers.psibi ];
  };
}
