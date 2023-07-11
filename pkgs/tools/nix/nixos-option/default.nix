{ lib, stdenv, boost, cmake, pkg-config, nix }:

stdenv.mkDerivation {
  name = "nixos-option";

  src = ./.;

  strictDeps = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost nix ];
  cmakeFlags = [ "-DNIX_DEV_INCLUDEPATH=${nix.dev}/include/nix" ];

  meta = with lib; {
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
    inherit (nix.meta) platforms;
  };
}
