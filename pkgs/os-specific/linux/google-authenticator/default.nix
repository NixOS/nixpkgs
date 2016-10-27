{ stdenv, lib, fetchurl, pam, qrencode }:

stdenv.mkDerivation rec {
  name = "google-authenticator-1.0";

  src = fetchurl {
    url = "https://google-authenticator.googlecode.com/files/libpam-${name}-source.tar.bz2";
    sha1 = "017b7d89989f1624e360abe02d6b27a6298d285d";
  };

  buildInputs = [ pam ];

  preConfigure = ''
    sed -i 's|libqrencode.so.3|${qrencode}/lib/libqrencode.so.3|' google-authenticator.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/security
    cp pam_google_authenticator.so $out/lib/security
    cp google-authenticator $out/bin
  '';

  meta = with lib; {
    homepage = https://code.google.com/p/google-authenticator/;
    description = "Two-step verification, with pam module";
    license = licenses.asl20;
    maintainers = with maintainers; [ aneeshusa ];
    platforms = platforms.linux;
  };
}
