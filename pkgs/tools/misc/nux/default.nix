{ lib
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
}:

let
  pname = "nux";
  version = "0.1.4";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "NuxPackage";
    repo = pname;
    rev = version;
    hash = "sha256-k3HRaWN8/MTZRGWBxI8RRK0tcSYBbSLs3vHkUdLGTc8";
  };

  cargoHash = "sha256-wfUr3dcdALMEgJ6CaXhK4Gqk6xflCnov9tELA63drV4=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  postInstall = ''
    installManPage $releaseDir/build/nux-*/out/nux.1
    installShellCompletion $releaseDir/build/nux-*/out/nux.{bash,fish}
    installShellCompletion $releaseDir/build/nux-*/out/_nux
  '';

  meta = {
    homepage = "https://github.com/NuxPackage/nux";
    description = "Wrapper over the nix cli";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
    mainProgram = "nux";
  };
}
