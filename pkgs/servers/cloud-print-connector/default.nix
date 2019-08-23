{ stdenv, buildGoPackage, fetchFromGitHub, avahi, cups }:

# TODO: Add a service for gcp-cups-connector and perhaps some other
# kind of configuration for the same thing that gcp-connector-util
# provides.

# Mic92 has an example module:
# - https://github.com/Mic92/dotfiles/blob/ba2a01144cfdc71c829d872a3fc816c64663ad7f/nixos/vms/matchbox/modules/cloud-print-connector.nix

buildGoPackage rec {
  name = "cloud-print-connector-unstable-${version}";
  version = "1.16";
  rev = "481ad139cc023a3ba65e769f08f277368fa8a5de";

  goPackagePath = "github.com/google/cloud-print-connector";

  subPackages = [
    "gcp-connector-util"
    "gcp-cups-connector"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "cloud-print-connector";
    sha256 = "0z2xad4wsv962rc1rspghfcfkz4nj2j5l5cm7xyn6qmsag0m8y2x";
    rev = "v${version}";
  };

  # To compute a new go2nix deps.go file,
  # change to the gcp-connector-util directory and create a nix-shell with avahi and
  # cups in it.

  # manually mirrored from launchpad because cloning failed due insecure http protocol
  # {
  #   goPackagePath = "launchpad.net/go-xdg/v0";
  #   fetch = {
  #     type = "git";
  #     url = "https://github.com/Mic92/go-xdg";
  #     rev = "b3fc6b3106d78701853b0caf62ebedae42769af2";
  #     sha256 = "0fd68kkxzxjanpgannpys962bxzqdf8c1qvzk687hv504a3dp76f";
  #   };
  # }
  goDeps = ./deps.nix;

  buildInputs = [ avahi cups ];

  meta = with stdenv.lib; {
    description = "Share printers from your Windows, Linux, FreeBSD or macOS computer with ChromeOS and Android devices, using the Cloud Print Connector";
    homepage = https://github.com/google/cloud-print-connector;
    license = licenses.bsd3;
    maintainers = with maintainers; [ hodapp ];
    # TODO: Fix broken build on macOS.  The GitHub presently lists the
    # FreeBSD build as broken too, but this may change in the future.
    platforms = platforms.unix;
  };
}
