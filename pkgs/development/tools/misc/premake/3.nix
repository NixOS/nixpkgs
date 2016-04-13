{stdenv, fetchurl, unzip}:

let baseName = "premake";
  version  = "3.7";
in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/premake/${baseName}-src-${version}.zip";
    sha256 = "b59841a519e75d5b6566848a2c5be2f91455bf0cc6ae4d688fcbd4c40db934d5";
  };

  buildInputs = [unzip];

  installPhase = ''
    install -Dm755 bin/premake $out/bin/premake
  '';

  meta = {
    homepage = http://industriousone.com/premake;
    description = "A simple build configuration and project generation tool using lua";
    license = stdenv.lib.licenses.bsd3;
  };
}
