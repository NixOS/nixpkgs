{ stdenv, buildPerlPackage, fetchurl, Error, MailDKIM, MIMEtools, NetServer}:

let
  pkg = "dkimproxy";
  version = "1.4.1";
in
buildPerlPackage rec {
  name = "${pkg}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dkimproxy/${name}.tar.gz";
    sha256 = "1gc5c7lg2qrlck7b0lvjfqr824ch6jkrzkpsn0gjvlzg7hfmld75";
  };

  propagatedBuildInputs = [ Error MailDKIM MIMEtools NetServer ];

  # Disable all things adapted to library perl packages
  doCheck = false;
  outputs = [ "out" ];

  # Use "normal" build setup
  configurePhase = ''
    ./configure --prefix=$out
  '';
  installPhase = ''
    make install
  '';

  meta = {
    description = "SMTP-proxy that signs and/or verifies emails";
    homepage = http://dkimproxy.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
