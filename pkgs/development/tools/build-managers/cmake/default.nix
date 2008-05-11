args: with args;
stdenv.mkDerivation {
  name = "cmake-2.6.0";
  setupHook = ./setup-hook.sh;

  src = fetchurl { url=http://www.cmake.org/files/v2.6/cmake-2.6.0.tar.gz;
                   sha256 = "09qgk5gk0pnihzf2mmqz5cayd64y5viic8x78x4czrh4982x76a9";
  };

  propagatedBuildInputs = [replace];

  postUnpack = "source \${setupHook}; fixCmakeFiles \${sourceRoot}";

  postInstall="fixCmakeFiles \$out/share";

  meta = {
    description = "Cross-Platform Makefile Generator";
  };
}
