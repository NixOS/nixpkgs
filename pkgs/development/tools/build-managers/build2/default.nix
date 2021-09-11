{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "build2";
  version = "0.13.0";

  src = fetchurl {
    url = "https://download.build2.org/${version}/build2-toolchain-${version}.tar.xz";
    sha256 = "01hmr5y8aa28qchwy9ci8x5q746flwxmlxarmy4w9zay9nmvryms";
  };

  dontConfigure = true;
  dontInstall = true;

  buildPhase = ''
    runHook preBuild
    ./build.sh --local --trust yes --install-dir "$out" "$CXX"
    runHook postBuild
  '';

  meta = with lib; {
    homepage = "https://www.build2.org/";
    description = "build2 build system";
    license = licenses.mit;
    longDescription = ''
      build2 is an open source (MIT), cross-platform build toolchain
      that aims to approximate Rust Cargo's convenience for developing
      and packaging C/C++ projects while providing more depth and
      flexibility, especially in the build system.

      build2 is a hierarchy of tools consisting of a general-purpose
      build system, package manager (for package consumption), and
      project manager (for project development). It is primarily aimed
      at C/C++ projects as well as mixed-language projects involving
      one of these languages (see bash and rust modules, for example).
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ hiro98 r-burns ];
  };
}
