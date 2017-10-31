{ stdenv, fetchurl, pam, openssl, perl }:

stdenv.mkDerivation rec {
  name = "pam_ssh_agent_auth-0.10.3";

  src = fetchurl {
    url = "mirror://sourceforge/pamsshagentauth/${name}.tar.bz2";
    sha256 = "0qx78x7nvqdscyp04hfijl4rgyf64xy03prr28hipvgasrcd6lrw";
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
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
