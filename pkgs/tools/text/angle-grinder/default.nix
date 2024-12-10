{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/OYIG4s0hH/bkAPxt/x5qHopDIoMN9AJLQ8Sx8USgsM=";
  };

  cargoHash = "sha256-pOW2jFQxaf2zQWL5+URvHVeCAvSI0u8iALPO5fCoqmI=";

  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "agrind";
  };
}
