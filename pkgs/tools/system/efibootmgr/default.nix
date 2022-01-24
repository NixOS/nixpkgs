{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, efivar, popt }:

stdenv.mkDerivation rec {
  pname = "efibootmgr";
  version = "17";

  nativeBuildInputs = [ pkg-config ];

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

  makeFlags = [ "EFIDIR=nixos" "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config" ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = "https://github.com/rhboot/efibootmgr";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
