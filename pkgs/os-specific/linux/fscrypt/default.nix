{ lib, buildGoModule, fetchFromGitHub, gnum4, pam, fscrypt-experimental }:

# Don't use this for anything important yet!

buildGoModule rec {
  pname = "fscrypt";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "sha256-1pXeqG7RZRT6EgWVnjBp2Ea4Cr2Y3xXa//30JXIZJec=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TAG_VERSION := $(shell git describe --tags)' "" \
      --replace "/usr/local" "$out"
  '';

  vendorSha256 = "sha256-6zcHz7ePJFSxxfIlhVK2VEf6+soBoUInT9ZsZK/Ag78=";

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
