{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-9gBrFudzn75rzx7bTPgr+zzUpX2cLHOmE12xFtoH1eA=";
  };

  cargoHash = "sha256-/f67AhaNLHS/3veAzNZwYujMMM/Vmq/U4MHNHvfRoBE=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    mainProgram = "nixdoc";
    homepage = "https://github.com/nix-community/nixdoc";
    license = [ licenses.gpl3 ];
    maintainers = with maintainers; [
      infinisil
      hsjobeki
    ];
    platforms = platforms.unix;
  };
}
