{ lib
, rustPlatform
, fetchCrate
, installShellFiles
, ronn
}:

rustPlatform.buildRustPackage rec {
  pname = "termimage";
  version = "1.2.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1FOPe466GqQfiIpsQT9DJn+FupI2vy9b4+7p31ceY6M=";
  };

  cargoHash = "sha256-Up6wvkZJ4yLrXp/2sEAv5RqGbhLOQPNHO2vEy2Vhy+E=";

  nativeBuildInputs = [
    installShellFiles
    ronn
  ];

  postInstall = ''
    ronn --roff --organization="termimage developers" termimage.md
    installManPage termimage.1
  '';

  meta = with lib; {
    description = "Display images in your terminal";
    homepage = "https://github.com/nabijaczleweli/termimage";
    changelog = "https://github.com/nabijaczleweli/termimage/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "termimage";
  };
}
