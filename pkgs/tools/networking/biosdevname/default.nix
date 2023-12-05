{ lib, stdenv, fetchFromGitHub, autoreconfHook, zlib, pciutils }:

stdenv.mkDerivation rec {
  pname = "biosdevname";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "biosdevname";
    rev = "v${version}";
    sha256 = "19wbb79x9h79k55sgd4dylvdbhhrvfaiaknbw9s1wvfmirkxa1dz";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib pciutils ];

  # Don't install /lib/udev/rules.d/*-biosdevname.rules
  patches = [ ./makefile.patch ];

  configureFlags = [ "--sbindir=\${out}/bin" ];

  meta = with lib; {
    description = "Udev helper for naming devices per BIOS names";
    license = licenses.gpl2;
    platforms = ["x86_64-linux" "i686-linux"];
    maintainers = with maintainers; [ ];
  };
}
