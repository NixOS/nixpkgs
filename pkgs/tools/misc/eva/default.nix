{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-eX2d9h6zNbheS68j3lyhJW05JZmQN2I2MdcmiZB8Mec=";
  };

  cargoSha256 = "sha256-gnym2sedyzQzubOtj64Yoh+sKT+sa60w/Z72hby7Pms=";

  meta = with lib; {
    description = "A calculator REPL, similar to bc";
    homepage = "https://github.com/NerdyPepper/eva";
    license = licenses.mit;
    maintainers = with maintainers; [
      nrdxp
      ma27
      figsoda
    ];
    mainProgram = "eva";
  };
}
