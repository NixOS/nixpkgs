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
    rev = "74b863e6dcb1ec2e6c8fb02c16bb6f23b59e67f6";
    hash = "sha256-Yujki2vGzaT8Ze5Usk8FPg8bn86MvyyPTiWuWwEw7Xs=";
  };

in
rustPlatform.buildRustPackage {
  pname = "tuxedo-rs";
  version = "0.2.3";

  inherit src;

  # Some of the tests are impure and rely on files in /etc/tailord
  doCheck = false;

  cargoHash = "sha256-uYt442u/BIzw/lBu18LrsJf5D46oUOFzBJ5pUjCpK6w=";

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

