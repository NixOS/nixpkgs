{ lib
, fetchFromGitHub
, rustPlatform
}:
let

  # NOTE: This src is shared with tailor-gui.
  # When updating, the tailor-gui.cargoDeps hash needs to be updated.
  src = fetchFromGitHub {
    owner = "AaronErhardt";
    repo = "tuxedo-rs";
    rev = "a77a9f6c64e6dd1ede3511934392cbc16271ef6b";
    hash = "sha256-bk17vI1gLHayvCWfmZdCMqgmbJFOTDaaCaHcj9cLpMY=";
  };

in
rustPlatform.buildRustPackage {
  pname = "tuxedo-rs";
  version = "0.2.2";

  inherit src;

  # Some of the tests are impure and rely on files in /etc/tailord
  doCheck = false;

  cargoHash = "sha256-vuXqab9W8NSD5U9dk15xM4fM/vd/fGgGdsvReMncWHg=";

  postInstall = ''
    install -Dm444 tailord/com.tux.Tailor.conf -t $out/share/dbus-1/system.d
  '';

  meta = with lib; {
    description = "Rust utilities for interacting with hardware from TUXEDO Computers";
    longDescription = ''
      An alternative to the TUXEDO Control Center daemon.

      Contains the following binaries:
      - tailord: Daemon handling fan, keyboard and general HW support for Tuxedo laptops
      - tailor: CLI
    '';
    homepage = "https://github.com/AaronErhardt/tuxedo-rs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mrcjkb ];
    platforms = platforms.linux;
  };
}

