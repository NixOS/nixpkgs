{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g5TC+4DGbTAlG39R8QIM5cB3/mtkp/vz8puB0Kr6aag=";
  };

  cargoSha256 = "sha256-AiWKSWwMh6KWCTTRRCBxekv2rukz+ijnRit11K/AnhU=";

  meta = with lib; {
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
