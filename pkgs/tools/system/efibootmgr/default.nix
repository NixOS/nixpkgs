{ stdenv, fetchFromGitHub, perl, efivar, pciutils, zlib }:

stdenv.mkDerivation rec {
  name = "efibootmgr-${version}";
  version = "0.12";

  buildInputs = [ perl efivar pciutils zlib ];

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efibootmgr";
    rev = name;
    sha256 = "0fmrsp67dln76896fvxalj2pamyp9dszf32kl06wdfi0km42z8sh";
  };

  NIX_CFLAGS_COMPILE = "-I${efivar}/include/efivar";
  NIX_LDFLAGS = "-lefiboot -lefivar";

  postPatch = ''
    substituteInPlace "./tools/install.pl" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  installFlags = [ "BINDIR=$(out)/sbin" ];

  meta = with stdenv.lib; {
    description = "A Linux user-space application to modify the Intel Extensible Firmware Interface (EFI) Boot Manager";
    homepage = http://linux.dell.com/efibootmgr/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
