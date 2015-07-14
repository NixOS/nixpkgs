{ stdenv, fetchurl, mpd_clientlib, curl, glib, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.1";
  name = "nixos-scripts-${version}";

  src = fetchurl {
    url = "https://github.com/matthiasbeyer/nixos-scripts/archive/v${version}.tar.gz";
    sha256 = "172kp9jibkyfdz3ajqga8k4jfdgr2db21zhw5kankz5lnfb4yv2q";
  };

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./nix-* $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Utility scripts for working with nixos tools";
    homepage = https://github.com/matthiasbeyer/nixos-scripts;
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

