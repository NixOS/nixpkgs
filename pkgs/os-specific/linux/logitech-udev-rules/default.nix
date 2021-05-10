{ lib, stdenv, solaar }:

# ltunifi and solaar both provide udev rules but solaar's rules are more
# up-to-date so we simply use that instead of having to maintain our own rules

stdenv.mkDerivation {
  pname = "logitech-udev-rules";
  inherit (solaar) version;

  buildCommand = ''
    install -Dm444 -t $out/etc/udev/rules.d ${solaar.src}/rules.d/*.rules
  '';

  meta = with lib; {
    description = "udev rules for Logitech devices";
    inherit (solaar.meta) homepage license platforms;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
