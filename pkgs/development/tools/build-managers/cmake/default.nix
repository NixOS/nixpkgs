args: with args;
stdenv.mkDerivation {
  name = "cmake-2.4.7";
  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = http://www.cmake.org/files/v2.4/cmake-2.4.7.tar.gz;
    sha256 = "0mkx23s7zq48hzzzw3vbzsfzfz3rjsiwgf3i00xawcxrjjrgxm9g";
  };

  propagatedBuildInputs = [replace];

  postUnpack = "source \${setupHook}; fixCmakeFiles \${sourceRoot}";

  postInstall="fixCmakeFiles \$out/share";

  meta = {
    description = "Cross-Platform Makefile Generator";
  };
}
