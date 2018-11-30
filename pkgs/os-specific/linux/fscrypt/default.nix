{ stdenv, buildGoPackage, fetchFromGitHub, pam }:

# Don't use this for anything important yet!

buildGoPackage rec {
  name = "fscrypt-${version}";
  version = "0.2.4";

  goPackagePath = "github.com/google/fscrypt";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "v${version}";
    sha256 = "10gbyqzgi30as1crvqbb4rc5p8zzbzk1q5j080h1gnz56qzwivr8";
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
