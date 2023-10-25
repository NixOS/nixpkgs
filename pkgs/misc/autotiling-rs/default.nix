{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "autotiling-rs";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LQbmF2M6pWa0QEbKF770x8TFLMGrJeq5HnXHvLrDDPA=";
  };

  cargoHash = "sha256-wot5GKBA2TBrA/jnWD0eypPRqUodmk/TJlYJMl3/gm4=";

  meta = with lib; {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
