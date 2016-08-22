{ stdenv, fetchFromGitHub, perl, efivar, pciutils, zlib, popt }:

stdenv.mkDerivation rec {
  name = "efibootmgr-${version}";
  version = "13";

  buildInputs = [ perl efivar pciutils zlib popt ];

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efibootmgr";
    rev = version;
    sha256 = "1kwmvx111c3a5783kx3az76mkhpr1nsdx0yv09gp4k0hgzqlqj96";
  };

  NIX_CFLAGS_COMPILE = "-I${efivar}/include/efivar";
  NIX_LDFLAGS = "-lefiboot -lefivar -lpopt";

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = http://linux.dell.com/efibootmgr/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
