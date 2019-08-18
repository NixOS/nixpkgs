{ stdenv, fetchurl, xcbuildHook, Foundation, AddressBook }:

stdenv.mkDerivation rec {
  version = "1.1a-3";
  pname = "contacts";

  src = fetchurl {
    url = "https://github.com/dhess/contacts/archive/4092a3c6615d7a22852a3bafc44e4aeeb698aa8f.tar.gz";
    sha256 = "0wdqc1ndgrdhqapvvgx5xihc750szv08lp91x4l6n0gh59cpxpg3";
  };

  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ Foundation AddressBook ];

  installPhase = ''
    mkdir -p $out/bin
    cp Products/Default/contacts $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Access contacts from the Mac address book from command-line";
    homepage    = http://www.gnufoo.org/contacts/contacts.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ jwiegley ];
    platforms   = stdenv.lib.platforms.darwin;
    hydraPlatforms = stdenv.lib.platforms.darwin;
  };
}
