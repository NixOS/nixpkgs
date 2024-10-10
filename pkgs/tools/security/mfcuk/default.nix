{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libnfc }:

stdenv.mkDerivation {
  pname = "mfcuk";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = "mfcuk";
    rev = "mfcuk-0.3.8";
    hash = "sha256-eSJHO0Dew8JqU0u52wDqafK5EHgqXqO5IZBcjXSGwaA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libnfc ];

  postConfigure = ''
    substituteInPlace src/mfcuk_finger.c --replace ./data/ $out/share/
  '';

  postInstall = ''
    mkdir -p $out/share
    cp -r src/data/tmpls_fingerprints $out/share/
  '';

  meta = with lib; {
    description = "MiFare Classic Universal toolKit";
    mainProgram = "mfcuk";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/nfc-tools/mfcuk";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
