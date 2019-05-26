{ stdenv, lib, fetchurl, autoreconfHook, pam, qrencode }:

stdenv.mkDerivation rec {
  name = "google-authenticator-libpam-${version}";
  version = "1.06";

  src = fetchurl {
    url = "https://github.com/google/google-authenticator-libpam/archive/${version}.tar.gz";
    sha256 = "01kb1ppsc2fz1i3crdwi6ic8gyphjv89f5li6ypv3pp88v3kxw2j";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam ];

  preConfigure = ''
    sed -i "s|libqrencode.so.4|${qrencode.out}/lib/libqrencode.so.4|" src/google-authenticator.c
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/security
    cp ./.libs/pam_google_authenticator.so $out/lib/security
    cp google-authenticator $out/bin
  '';

  meta = with lib; {
    homepage = https://github.com/google/google-authenticator-libpam;
    description = "Two-step verification, with pam module";
    license = licenses.asl20;
    maintainers = with maintainers; [ aneeshusa ];
    platforms = platforms.linux;
  };
}
