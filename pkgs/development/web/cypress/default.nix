{ stdenv, pkgs, fetchurl, atomEnv, gtk2-x11, unzip }:

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

in stdenv.mkDerivation rec {
  name = "cypress";
  src = fetchurl {
    url = "https://cdn.cypress.io/desktop/3.1.5/linux64/cypress.zip";
    sha256 = "19ilnb0ww8zvzxv0pq0qsjy6zp789c26rw6559j8q2s3f59jqv05";
  };

  buildInputs = [ unzip ];

  phases = "unpackPhase fixupPhase";

  targetPath = "$out/Cypress/3.1.5";

  unpackPhase = ''
    mkdir -p ${targetPath}
    unzip $src -d ${targetPath}
  '';

  rpath = with pkgs; lib.makeLibraryPath [
    atomEnv.libPath
    gtk2-x11
  ];

  fixupPhase = ''
    patchelf \
      --set-interpreter "${dynamic-linker}" \
      --set-rpath "${rpath}:${targetPath}/Cypress" \
      ${targetPath}/Cypress/Cypress
  '';

  meta = with stdenv.lib; {
    description = "Fast, easy and reliable testing for anything that runs in a browser";
    homepage = https://www.cypress.io/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.acyuta108 ];
  };
}
