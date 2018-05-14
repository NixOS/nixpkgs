{ stdenv, fetchFromGitHub, pkgconfig, efivar, popt }:

stdenv.mkDerivation rec {
  name = "efibootmgr-${version}";
  version = "16";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ efivar popt ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efibootmgr";
    rev = version;
    sha256 = "0b27h8vf1b6laln5n0wk2hkzyyh87sxanj7wrz9kimyx03dcq6vi";
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
