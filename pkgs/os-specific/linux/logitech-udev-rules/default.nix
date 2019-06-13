{ stdenv, solaar }:

# ltunifi and solaar both provide udev rules but solaar's rules are more
# up-to-date so we simply use that instead of having to maintain our own rules

stdenv.mkDerivation rec {
  name = "logitech-udev-rules-${version}";
  inherit (solaar) version;

  buildCommand = ''
    install -Dm644 -t $out/etc/udev/rules.d ${solaar.src}/rules.d/*.rules
  '';

  meta = with stdenv.lib; {
    description = "udev rules for Logitech devices";
    inherit (solaar.meta) homepage license platforms;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
