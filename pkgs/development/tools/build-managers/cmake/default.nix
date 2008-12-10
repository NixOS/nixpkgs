{fetchurl, stdenv, replace}:

stdenv.mkDerivation rec {
  name = "cmake-2.6.2";
  setupHook = ./setup-hook.sh;
  meta = {
    description = "Cross-Platform Makefile Generator";
  };
  src = fetchurl {
    url = "http://www.cmake.org/files/v2.6/${name}.tar.gz";
    sha256 = "b3f5a9dfa97fb82cb1b7d78a62d949f93c8d4317af36674f337d27066fa6b7e9";
  };
  propagatedBuildInputs = [replace];
  postUnpack = "source \${setupHook}; fixCmakeFiles \${sourceRoot}";
  postInstall="fixCmakeFiles \$out/share";
}
