{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-DuwH0qie8SctvOGntljOdTRMGKrNFPycdaFG3QZxihA=";
  };

  cargoHash = "sha256-vDpuIWB5pbhYrFgQ1ogALMJpZvy8ETZtneX1fjpjl+0=";

  meta = with lib; {
    description = "SystemVerilog language server";
    mainProgram = "svls";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
