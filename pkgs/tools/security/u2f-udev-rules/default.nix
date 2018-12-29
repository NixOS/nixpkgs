{ stdenv, fetchFromGitHub }:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.u2f-udev-rules ];

stdenv.mkDerivation rec {
  name = "u2f-udev-rules-${version}";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "libu2f-host";
    rev = "libu2f-host-" + version;
    sha256 = "3735fe2e4c763fc998a6a7d8401b26ec0efbae0dfe943bdd521962d07d68c01a";
  };

  dontBuild = true;

  installPhase = ''
    install -D 70-u2f.rules $out/lib/udev/rules.d/70-u2f.rules
  '';

  meta = {
    homepage = https://support.yubico.com/support/solutions/articles/15000006449-using-your-u2f-yubikey-with-linux;
    description = "udev rules for your U2F key like a Yubikey";
    longDescription = ''
      These udev rules written by Yubico, the makers of the Yubikey add support for the
      Yubikey, Happlink Security Key, HyperSecu HyperFIDO, Feitian ePass FIDO, JaCarta U2F,
      U2F Zero, VASCO SecureClick, Bluink Key, Thetis Key, Nitrokey FIDO U2F and the Google Titan U2F.
      Simply add this to your configuration: services.udev.packages = [ pkgs.u2f-udev-rules ];
    '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ benbals ];
  };
}
