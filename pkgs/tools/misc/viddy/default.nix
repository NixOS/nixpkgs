{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "viddy";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "viddy";
    rev = "v${version}";
    hash = "sha256-Rb4IBguyRLiwUR9dDKOagWSUjov0OzxiiuSg7epjCv0=";
  };

  cargoHash = "sha256-Lr/sl0IcoVGb22y5BQrGIUVx8Ny+bQg1MqUBRPqF1nk=";

  # requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  env.VERGEN_BUILD_DATE = "2024-08-26"; # managed via the update script
  env.VERGEN_GIT_DESCRIBE = "Nixpkgs";

  passthru.updateScript.command = [ ./update.sh ];

  meta = with lib; {
    description = "Modern watch command, time machine and pager etc.";
    changelog = "https://github.com/sachaos/viddy/releases";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [
      j-hui
      phanirithvij
    ];
    mainProgram = "viddy";
  };
}
