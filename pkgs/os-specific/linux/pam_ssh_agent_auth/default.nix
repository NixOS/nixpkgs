{ stdenv, fetchurl, pam, openssl, perl }:

stdenv.mkDerivation rec {
  name = "pam_ssh_agent_auth-0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/pamsshagentauth/${name}.tar.bz2";
    sha256 = "19p5mzplnr9g9vlp16nipf5rjw4v8zncvimarwgix958yml7j08h";
  };

  buildInputs = [ pam openssl perl ];

  meta = {
    homepage = http://pamsshagentauth.sourceforge.net/;
    description = "PAM module for authentication through the SSH agent";
  };
}
