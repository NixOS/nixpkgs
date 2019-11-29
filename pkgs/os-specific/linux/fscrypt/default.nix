{ stdenv, buildGoPackage, fetchFromGitHub, pam }:

# Don't use this for anything important yet!

buildGoPackage rec {
  pname = "fscrypt";
  version = "0.2.5";

  goPackagePath = "github.com/google/fscrypt";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "1jf6363kc9id3ar93znlcglx3llgv01ccp3nlbamm98rm9dps4qk";
  };

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
