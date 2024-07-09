{ stdenv, lib, fetchFromGitHub, autoreconfHook, pam, qrencode }:

stdenv.mkDerivation rec {
  pname = "google-authenticator-libpam";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "google-authenticator-libpam";
    rev = version;
    hash = "sha256-KEfwQeJIuRF+S3gPn+maDb8Fu0FRXLs2/Nlbjj2d3AE=";
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
    homepage = "https://github.com/google/google-authenticator-libpam";
    description = "Two-step verification, with pam module";
    mainProgram = "google-authenticator";
    license = licenses.asl20;
    maintainers = with maintainers; [ aneeshusa ];
    platforms = platforms.linux;
  };
}
