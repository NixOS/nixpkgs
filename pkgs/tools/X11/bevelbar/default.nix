{ lib,
  stdenv,
  fetchurl,
  pkg-config,
  libX11,
  libXft,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bevelbar";
  version = "22.06";

  src = fetchurl {
    url = "https://www.uninformativ.de/git/bevelbar/archives/bevelbar-v${finalAttrs.version}.tar.gz";
    hash = "sha256-8ceFwQFHhJ1qEXJtzoDXU0XRgudaAfsoWq7LYgGEqsM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXft
    libXrandr
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://www.uninformativ.de/git/bevelbar/file/README.html";
    description = "X11 status bar with beveled borders";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres neeasade ];
    platforms = platforms.linux;
  };
})
