{ stdenv, buildGoModule, fetchFromGitHub, pam }:

# Don't use this for anything important yet!

buildGoModule rec {
  pname = "fscrypt";
  version = "0.2.5";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "1jf6363kc9id3ar93znlcglx3llgv01ccp3nlbamm98rm9dps4qk";
  };

  modSha256 = "0x6jq895cc2jvxjzvc4dpx2c1ml6ggm7gmdd1wgab6q0wzqasfcq";

  buildInputs = [ pam ];

  meta = with stdenv.lib; {
    description =
      "A high-level tool for the management of Linux filesystem encryption";
    longDescription = ''
      This tool manages metadata, key generation, key wrapping, PAM integration,
      and provides a uniform interface for creating and modifying encrypted
      directories.
    '';
    inherit (src.meta) homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
