{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "premake";
  version = "4.3";

  src = fetchurl {
    url = "mirror://sourceforge/premake/premake-${version}-src.zip";
    sha256 = "1017rd0wsjfyq2jvpjjhpszaa7kmig6q1nimw76qx3cjz2868lrn";
  };

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    make -C build/gmake.unix/
  '';

  installPhase = ''
    install -Dm755 bin/release/premake4 $out/bin/premake4
  '';

  premake_cmd = "premake4";
  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Simple build configuration and project generation tool using lua";
    homepage = "https://premake.github.io/";
    license = lib.licenses.bsd3;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "premake4";
    platforms = platforms.unix;
  };
}
