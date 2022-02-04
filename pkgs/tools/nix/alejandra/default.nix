{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "unstable-2022-01-30";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = "b72274b052ae06cbe60a97d623829b1458369cc2";
    sha256 = "sha256-snq9C/a/53VivFcLNvdeKwVmPBXbcVzbbjTB+iULFUc=";
  };

  cargoSha256 = "sha256-/JzATzRhNexmyjtgjHVkw8LVyr4PdIdPJfUGXz4pZbQ=";

  meta = with lib; {
    description = "The uncompromising Nix formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
