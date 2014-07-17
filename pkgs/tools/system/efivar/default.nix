{ stdenv, fetchgit, popt }:

stdenv.mkDerivation rec {
  name = "efivar-${version}";
  version = "0.10";

  src = fetchgit {
    url = "git://github.com/vathpela/efivar.git";
    rev = "refs/tags/${version}";
    sha256 = "04fznbmrf860b4d4i8rshx3mgwbx06v187wf1rddvxxnpkq8920w";
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
