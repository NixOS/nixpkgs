{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cairo,
}:

stdenv.mkDerivation rec {
  pname = "inav-blackbox-tools";
  version = "unstable-2021-04-22";

  src = fetchFromGitHub {
    owner = "iNavFlight";
    repo = "blackbox-tools";
    rev = "0109e2fb9b44d593e60bca4cef4098d83c55c373";
    sha256 = "1rdlw74dqq0hahnka2w2pgvs172vway2x6v8byxl2s773l22k4ln";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ cairo ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp obj/{blackbox_decode,blackbox_render,encoder_testbed} "$out/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools for working with blackbox flight logs";
    homepage = "https://github.com/inavflight/blackbox-tools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/inav-blackbox-tools.x86_64-darwin
  };
}
