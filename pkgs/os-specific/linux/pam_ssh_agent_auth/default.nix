{ stdenv, fetchurl, pam, openssl, perl }:

stdenv.mkDerivation rec {
  name = "pam_ssh_agent_auth-0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/pamsshagentauth/${name}.tar.bz2";
    sha256 = "1a8cv223f30mvkxnyh9hk6kya0ynkwwkc5nhlz3rcqhxfw0fcva9";
  };

  patches =
    [ # Allow multiple colon-separated authorized keys files to be
      # specified in the file= option.
      ./multiple-key-files.patch
    ];

  buildInputs = [ pam openssl perl ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://pamsshagentauth.sourceforge.net/;
    description = "PAM module for authentication through the SSH agent";
  };
}
