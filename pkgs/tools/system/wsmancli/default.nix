{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, openssl, openwsman }:

stdenv.mkDerivation rec {
  pname = "wsmancli";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner  = "Openwsman";
    repo   = "wsmancli";
    rev    = "v${version}";
    sha256 = "0a67fz9lj7xkyfqim6ai9kj7v6hzx94r1bg0g0l5dymgng648b9j";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ openwsman openssl ];

  postPatch = ''
    touch AUTHORS NEWS README
  '';

  meta = with lib; {
    description = "Openwsman command-line client";
    longDescription = ''
      Openwsman provides a command-line tool, wsman, to perform basic
      operations on the command-line. These operations include Get, Put,
      Invoke, Identify, Delete, Create, and Enumerate. The command-line tool
      also has several switches to allow for optional features of the
      WS-Management specification and Testing.
    '';
    downloadPage = "https://github.com/Openwsman/wsmancli/releases";
    inherit (openwsman.meta) homepage license maintainers platforms;
  };
}
