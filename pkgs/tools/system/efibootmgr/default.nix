{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, efivar, popt }:

stdenv.mkDerivation rec {
  pname = "efibootmgr";
  version = "17";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ efivar popt ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efibootmgr";
    rev = version;
    sha256 = "1niicijxg59rsmiw3rsjwy4bvi1n42dynvm01lnp9haixdzdpq03";
  };

  patches = [
    (fetchpatch {
      name = "remove-extra-decl.patch";
      url = "https://github.com/rhboot/efibootmgr/commit/99b578501643377e0b1994b2a068b790d189d5ad.patch";
      sha256 = "1sbijvlpv4khkix3vix9mbhzffj8lp8zpnbxm9gnzjz8yssz9p5h";
    })
  ];
  # We have no LTO here since commit 22284b07.
  postPatch = if stdenv.isi686 then "sed '/^CFLAGS/s/-flto//' -i Make.defaults" else null;

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
