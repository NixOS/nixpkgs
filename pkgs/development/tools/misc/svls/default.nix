{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "0qcd9pkshk94c6skzld8cyzppl05hk4vcmmaya8r9l6kdi1f4b5m";
  };

  cargoSha256 = "0dqa7iw0sffzh07qysznh7ma3d3vl5fhd0i2qmz7a3dvw8mvyvsm";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
