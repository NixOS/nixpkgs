{ lib, stdenv, fetchFromGitHub, libbfd, zlib, libiberty }:

stdenv.mkDerivation rec {
  pname = "wimboot";
  version = "2.7.6";

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "wimboot";
    rev = "v${version}";
    sha256 = "sha256-AFPuHxcDM/cdEJ5nRJnVbPk7Deg97NeSMsg/qwytZX4=";
  };

  sourceRoot = "${src.name}/src";

  buildInputs = [ libbfd zlib libiberty ];
  makeFlags = [ "wimboot.x86_64.efi" ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  installPhase = ''
    mkdir -p $out/share/wimboot/
    cp wimboot.x86_64.efi $out/share/wimboot
  '';

  meta = with lib; {
    homepage = "https://ipxe.org/wimboot";
    description = "Windows Imaging Format bootloader";
    license = licenses.gpl2Plus;
    maintainers = teams.helsinki-systems.members;
    platforms = [ "x86_64-linux" ];
  };
}
