{ lib, stdenv, fetchFromGitHub, xcbuildHook, Foundation, AddressBook }:

stdenv.mkDerivation {
  version = "1.1a-3";
  pname = "contacts";

  src = fetchFromGitHub {
    owner = "dhess";
    repo = "contacts";
    rev = "4092a3c6615d7a22852a3bafc44e4aeeb698aa8f";
    hash = "sha256-Li/c5uf9rfpuU+hduuSm7EmhVwIIkS72dqzmN+0cE3A=";
  };

  postPatch = ''
    substituteInPlace contacts.m \
      --replace "int peopleSort" "long peopleSort"
  '';

  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ Foundation AddressBook ];

  installPhase = ''
    mkdir -p $out/bin
    cp Products/Default/contacts $out/bin
  '';

  meta = with lib; {
    description = "Access contacts from the Mac address book from command-line";
    homepage = "http://www.gnufoo.org/contacts/contacts.html";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.darwin;
    hydraPlatforms = platforms.darwin;
  };
}
