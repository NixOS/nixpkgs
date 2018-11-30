{ stdenv, fetchFromGitHub, pkgconfig, efivar, popt }:

stdenv.mkDerivation rec {
  name = "efibootmgr-${version}";
  version = "17";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ efivar popt ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efibootmgr";
    rev = version;
    sha256 = "1niicijxg59rsmiw3rsjwy4bvi1n42dynvm01lnp9haixdzdpq03";
  };

  makeFlags = [ "EFIDIR=nixos" ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = https://github.com/rhboot/efibootmgr;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
