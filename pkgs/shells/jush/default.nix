{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  editline,
}:

stdenv.mkDerivation rec {
  pname = "jush";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1azvghrh31gawd798a254ml4id642qvbva64zzg30pjszh1087n8";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ editline ];

  passthru.shellPath = "/bin/jush";

  meta = with lib; {
    description = "just a useless shell";
    mainProgram = "jush";
    homepage = "https://github.com/troglobit/jush";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
