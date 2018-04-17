{ stdenv, lib, fetchurl, autoreconfHook, pam, qrencode }:

stdenv.mkDerivation rec {
  name = "google-authenticator-libpam-${version}";
  version = "1.05";

  src = fetchurl {
    url = "https://github.com/google/google-authenticator-libpam/archive/${version}.tar.gz";
    sha256 = "026vljmddi0zqcb3c0vdpabmi4r17kahc00mh6fs3qbyjbb14946";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam ];

  preConfigure = ''
    sed -i "s|libqrencode.so.3|${qrencode}/lib/libqrencode.so.3|" src/google-authenticator.c
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
