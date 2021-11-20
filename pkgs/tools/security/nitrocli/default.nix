{ pinentry, gnupg, libusb1, hidapi, lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "nitrocli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "d-e-s-o";
    repo = "nitrocli";
    rev = "8a8250f262100a95164a7b0ff8e1ea7d5c17e3a6";
    sha256 = "1lvl6z9xh479dzpdv11wnxdr9amm8np2037bg79i6im6y23jyn4g";
  };

  cargoSha256 = "0k58bckxxc7kjj3swsm5gg2pvxc7dn7k5s0bv1lajx9gxrhrb04n";

  buildInputs = [
    # These are needed to have an actually useful application, not strictly required, but you can't enter PINs without them...
    gnupg
    pinentry
    # Absolute requirements
    libusb1
    hidapi
  ];

  # Do not compile all binaries, just nitrocli (shell-complete is useless to us)
  cargoBuildFlags = [ "--bin=nitrocli" ];

  # Tests could cause massive problems and will only work on a factory reset device (assuming one is even connected during testing stage).
  # Disable all tests for now...
  doCheck = false;

  meta = {
    description = "A command line tool for interacting with nitrokey devices";
    longDescription = ''In order for this tool to work, you need to configure your gpg-agent to use your preferred pinentry program.'';
    homepage = "https://github.com/d-e-s-o/nitrocli";
    downloadPage = "https://github.com/d-e-s-o/nitrocli/releases";
    changelog = "https://github.com/d-e-s-o/nitrocli/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jauchi ];
    platforms = [ lib.platforms.linux ];
  };
}
