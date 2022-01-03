{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, dbus
, openssl
, runtimeShell
}:

rustPlatform.buildRustPackage rec {
  pname = "rescrobbled";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "InputUsername";
    repo = "rescrobbled";
    rev = "v${version}";
    sha256 = "stz0mrXEFDGx+XLxMttb2XXR5n7cpw86USZQiUaagSw=";
  };

  cargoSha256 = "IxlhLIIHvEFBd+PghLsRq4PIxFwnHBJd0+79pxelzi4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ];

  postPatch = ''
    # Required for tests.
    substituteInPlace src/filter.rs --replace '#!/usr/bin/bash' '#!${runtimeShell}'
  '';

  postInstall = ''
    substituteInPlace rescrobbled.service --replace '%h/.cargo/bin/rescrobbled' "$out/bin/rescrobbled"
    install -Dm644 rescrobbled.service -t "$out/share/systemd/user"
  '';

  meta = with lib; {
    description = "MPRIS music scrobbler daemon";
    homepage = "https://github.com/InputUsername/rescrobbled";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
