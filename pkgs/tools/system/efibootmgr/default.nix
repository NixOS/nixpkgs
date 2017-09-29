{ stdenv, fetchFromGitHub, pkgconfig, efivar, popt }:

stdenv.mkDerivation rec {
  name = "efibootmgr-${version}";
  version = "15";

  nativeBuildInputs = [ pkgconfig ];
  
  buildInputs = [ efivar popt ];

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efibootmgr";
    rev = version;
    sha256 = "0z7h1dirp8za6lbbf4f3dzn7l1px891rdymhkbqc10yj6gi1jpqp";
  };

  NIX_CFLAGS_COMPILE = "-I${efivar}/include/efivar";

  makeFlags = [ "EFIDIR=nixos" ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = https://github.com/rhinstaller/efibootmgr;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
