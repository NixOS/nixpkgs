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

  configureFlags = [ "--with-mantype=man" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://pamsshagentauth.sourceforge.net/;
    description = "PAM module for authentication through the SSH agent";
    maintainers = with maintainers; [ eelco ];
    license = licenses.openssl;
    platforms = platforms.linux;
  };
}
