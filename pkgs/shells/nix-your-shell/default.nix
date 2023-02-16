{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MXshCRgGL2V51Pd1ms6D0Sn0mtRcxd0pWUz+zghBTdI=";
  };

  cargoSha256 = "sha256-f1igCSdv6iMUDeCDGSxDIecjVcJQN2jbdALGMpDVepQ=";

  meta = with lib; {
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
