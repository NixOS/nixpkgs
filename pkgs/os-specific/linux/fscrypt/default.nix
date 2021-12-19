{ lib, buildGoModule, fetchFromGitHub, gnum4, pam, fscrypt-experimental }:

# Don't use this for anything important yet!

buildGoModule rec {
  pname = "fscrypt";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "0gi91vm0ai4vjzj6cfnjsfy8kbfxjiq2n7jnbhf5470qbx49qixr";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TAG_VERSION := $(shell git describe --tags)' "" \
      --replace "/usr/local" "$out"
  '';

  vendorSha256 = "1gw3q2pn8v6n9wkl5881rbxglislnr98a9gjqnqm894gnz7hfdzb";

  doCheck = false;

  nativeBuildInputs = [ gnum4 ];
  buildInputs = [ pam ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
  '';

  meta = with lib; {
    description =
      "A high-level tool for the management of Linux filesystem encryption";
    longDescription = ''
      This tool manages metadata, key generation, key wrapping, PAM integration,
      and provides a uniform interface for creating and modifying encrypted
      directories.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/google/fscrypt/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
