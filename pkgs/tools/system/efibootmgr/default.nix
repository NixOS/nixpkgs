{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  efivar,
  popt,
}:

stdenv.mkDerivation rec {
  pname = "efibootmgr";
  version = "18";

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efibootmgr";
    rev = version;
    hash = "sha256-DYYQGALEn2+mRHgqCJsA7OQCF7xirIgQlWexZ9uoKcg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    efivar
    popt
  ];

  makeFlags = [
    "EFIDIR=nixos"
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
  ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = "https://github.com/rhboot/efibootmgr";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
