{ stdenv, fetchurl, trousers, openssl, opencryptoki, perl }:

let
  version = "1.3.9.1";
in
stdenv.mkDerivation rec {
  name = "tpm-tools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/trousers/tpm-tools/${version}/${name}.tar.gz";
    sha256 = "0s7srgghykxnlb1g4izabzf2gfb1knxc0nzn6bly49h8cpi19dww";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ perl ];
  buildInputs = [ trousers openssl opencryptoki ];

  meta = with stdenv.lib; {
    description = "Management tools for TPM hardware";
    longDescription = ''
      tpm-tools is an open-source package designed to enable user and
      application enablement of Trusted Computing using a Trusted Platform
      Module (TPM), similar to a smart card environment.
    '';
    homepage    = http://sourceforge.net/projects/trousers/files/tpm-tools/;
    license     = licenses.cpl10;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.unix;
  };
}

