hash: args: with args;
stdenv.mkDerivation rec {
  name = "cmake-" + version;
  setupHook = ./setup-hook.sh;

  src = fetchurl ({
    url = "http://www.cmake.org/files/v${v}/${name}.tar.gz";
  } // hash);

  propagatedBuildInputs = [replace];

  postUnpack = "source ${setupHook}; fixCmakeFiles \${sourceRoot}";

  postInstall="fixCmakeFiles \$out/share";

  meta = {
    description = "Cross-Platform Makefile Generator";
  };
}
