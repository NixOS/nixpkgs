{lib, stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  pname = "premake";
  version  = "3.7";

  src = fetchurl {
    url = "mirror://sourceforge/sourceforge/premake/premake-src-${version}.zip";
    sha256 = "b59841a519e75d5b6566848a2c5be2f91455bf0cc6ae4d688fcbd4c40db934d5";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    install -Dm755 bin/premake $out/bin/premake
  '';

  premake_cmd = "premake";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://premake.github.io/";
    description = "A simple build configuration and project generation tool using lua";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
