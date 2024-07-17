{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libnfc,
}:

stdenv.mkDerivation {
  pname = "mfcuk";
  version = "0.3.8";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfcuk/mfcuk-0.3.8.tar.gz";
    sha256 = "0m9sy61rsbw63xk05jrrmnyc3xda0c3m1s8pg3sf8ijbbdv9axcp";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libnfc ];

  meta = with lib; {
    description = "MiFare Classic Universal toolKit";
    mainProgram = "mfcuk";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/nfc-tools/mfcuk";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
