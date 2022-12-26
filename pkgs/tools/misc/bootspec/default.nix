{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "bootspec";
  version = "unstable-2022-12-05";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "67a617ab6b99211daa92e748d27ead3f78127cf8";
    hash = "sha256-GX6Tzs/ClTUV9OXLvPFw6uBhrpCWSMI+PfrViyFEIxs=";
  };

  cargoHash = "sha256-N/hbfjsuvwCc0mxOpeVVcTxb5cA024lyLSEpVcrS7kA=";

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
    platforms = platforms.unix;
  };
}
