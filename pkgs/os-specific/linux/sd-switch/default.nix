<<<<<<< HEAD
{ lib, fetchFromSourcehut, rustPlatform, pkg-config, dbus }:

let version = "0.3.0";
in rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-mWrLbCUnoJ3hVtpSU/7dw91U5TLyw5kNchX5nmP9asA=";
  };

  cargoHash = "sha256-VK+kPX1pGhowbWKkUs1PL0DXIhDXJOFVoIHTtWQcWEs=";
=======
{ lib, fetchFromGitLab, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "sd-switch";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "rycee";
    repo = pname;
    rev = version;
    sha256 = "12h2d7v7pdz7b0hrna64561kf35nbpwb2kzxa791xk8raxc2b72k";
  };

  cargoSha256 = "12ny3cir2nxzrmf4vwq6sgc35dbpq88hav53xqdp44rigdf4vzbs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "A systemd unit switcher for Home Manager";
    homepage = "https://gitlab.com/rycee/sd-switch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
