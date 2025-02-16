{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "chars";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "antifuchs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mBtwdPzIc6RgEFTyReStFlhS4UhhRWjBTKT6gD3tzpQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Df+twOjzfq+Vxzuv+APiy94XmhBajgk+6+1BRFf+xm0=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = with lib; {
    description = "Commandline tool to display information about unicode characters";
    mainProgram = "chars";
    homepage = "https://github.com/antifuchs/chars";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
