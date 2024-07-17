{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
}:

stdenv.mkDerivation rec {
  pname = "wmutils";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "pockata";
    repo = "mmutils";
    rev = "v${version}";
    sha256 = "08wlb278m5lr218c87yqashk7farzny51ybl5h6j60i7pbpm01ml";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A set of utilities for querying xrandr monitor information";
    homepage = "https://github.com/pockata/mmutils";
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
