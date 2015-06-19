{ stdenv, fetchFromGitHub, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "14c8x9dhi4scj42n1cf513b551c1ccm8lwpaqx8h8ydpm2k35qi4";
  };

  buildInputs = [ popt ];

  installFlags = [
    "libdir=$(out)/lib"
    "mandir=$(out)/share/man"
    "includedir=$(out)/include"
    "bindir=$(out)/bin"
  ];

  meta = with stdenv.lib; {
    homepage = http://github.com/vathpela/efivar;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
