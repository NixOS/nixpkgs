{ stdenv, fetchFromGitLab, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "sd-switch";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "rycee";
    repo = pname;
    rev = version;
    sha256 = "0njihfqvvp4lm2572sw5xadwg3nrvx2i1qrfm7fi0i3v5pxdc7g0";
  };

  cargoSha256 = "0ba2j0v2z90fivwdr5akdrsz9f479gz20yh85yiy05rkjhjy8cvv";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  meta = with stdenv.lib; {
    description = "A systemd unit switcher for Home Manager";
    homepage = "https://gitlab.com/rycee/sd-switch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
