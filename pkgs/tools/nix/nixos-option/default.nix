{lib, stdenv, boost, cmake, pkg-config, nix, ... }:

stdenv.mkDerivation rec {
  name = "nixos-option";
  src = ./.;
  strictDeps = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost nix ];
  meta = with lib; {
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ chkno ];
    platforms = platforms.all;
  };
}
