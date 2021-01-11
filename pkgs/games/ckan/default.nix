{ lib, stdenv, fetchurl, makeWrapper, mono, gtk2, curl }:

stdenv.mkDerivation rec {
  pname = "ckan";
  version = "1.29.2";

  src = fetchurl {
    url = "https://github.com/KSP-CKAN/CKAN/releases/download/v${version}/ckan.exe";
    sha256 = "10vd61mw2y7vmbnp6nd7b2sq22ixqd7zmd278z210w4njmvqn97h";
  };

  dontUnpack = true;

  buildInputs = [ makeWrapper mono ];

  libraries = stdenv.lib.makeLibraryPath [ gtk2 curl ];

  buildPhase = "true";

  installPhase = ''
    install -m 644 -D $src $out/bin/ckan.exe
    makeWrapper ${mono}/bin/mono $out/bin/ckan \
      --add-flags $out/bin/ckan.exe \
      --set LD_LIBRARY_PATH $libraries
  '';

  meta = with lib; {
    description = "Mod manager for Kerbal Space Program";
    homepage = "https://github.com/KSP-CKAN/CKAN";
    license = licenses.mit;
    maintainers = with maintainers; [ Baughn ymarkus ];
    platforms = platforms.all;
  };
}
