<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, java
, coreutils
, which
, makeWrapper
  # For the test
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "apache-jena-fuseki";
  version = "4.9.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    hash = "sha256-t25Q0lb+ecR12cDD1p6eZnzLxW0kZpPOFGvo5YK7AlI=";
=======
{ lib, stdenv, fetchurl, java, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "apache-jena-fuseki";
  version = "4.8.0";
  src = fetchurl {
    url = "mirror://apache/jena/binaries/apache-jena-fuseki-${version}.tar.gz";
    hash = "sha256-rJCY8vG1vfEGGA0gsIqNFXKl75O2Zp4zUIWSDfplpVE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  nativeBuildInputs = [
    makeWrapper
  ];
  installPhase = ''
    cp -r . "$out"
    chmod +x $out/fuseki
    ln -s "$out"/{fuseki-backup,fuseki-server,fuseki} "$out/bin"
    for i in "$out"/bin/*; do
      wrapProgram "$i" \
<<<<<<< HEAD
        --prefix "PATH" : "${java}/bin/:${coreutils}/bin:${which}/bin" \
=======
        --prefix "PATH" : "${java}/bin/" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        --set-default "FUSEKI_HOME" "$out" \
        ;
    done
  '';
<<<<<<< HEAD
  passthru = {
    tests = {
      basic-test = pkgs.callPackage ./fuseki-test.nix { };
    };
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "SPARQL server";
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin ];
<<<<<<< HEAD
    platforms = platforms.all;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://jena.apache.org";
    downloadPage = "https://archive.apache.org/dist/jena/binaries/";
  };
}
