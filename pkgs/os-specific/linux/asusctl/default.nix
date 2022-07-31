{ lib, fetchFromGitLab, rustPlatform
, pkg-config
, udev
}:

with rustPlatform;

buildRustPackage rec {
  pname = "asusctl";
  version = "4.3.0";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = "asusctl";
    rev = version;
    hash = "sha256-s0y5oK079Mwg9RTbSbcW1jGjhRH0X/GnSPI1e/G8m1c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  cargoHash = "sha256-lKviCcwuJaLx+H9Qu6XXUFM3L99A4kgP1vR46hBhVRE=";

  preInstall = ''
    # Install the data.
    # Let buildRustPackage handle installing build output in installPhase.
    make install \
      DESTDIR="$out" \
      INSTALL_PROGRAM=true \
      INSTALL_DATA="install -D -m 0444" \
      prefix=""
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops.";
    homepage = https://gitlab.com/asus-linux/asusctl;
    license = with licenses; [ mpl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden kravemir ];
  };
}
