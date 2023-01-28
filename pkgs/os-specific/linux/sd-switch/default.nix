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
