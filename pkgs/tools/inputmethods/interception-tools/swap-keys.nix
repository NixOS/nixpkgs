{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libevdev }:

stdenv.mkDerivation rec {
  pname = "swap-keys";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "amfranz";
    repo = "swap-keys";
    rev = "v1.0";
    hash = "sha256-fAFlcxJlsc1kITxCaSMH8Fi2AXlgK8EHayoWWN1hC70=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libevdev ];

  meta = with lib; {
    homepage = "https://github.com/amfranz/swap-keys";
    description = "Swap arbitrary pairs of keys";
    license = licenses.mit;
    maintainers = with maintainers; [ chairbender ];
    platforms = platforms.linux;
    mainProgram = "swap-keys";
  };
}
