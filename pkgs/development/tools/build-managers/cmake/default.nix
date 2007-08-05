{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "cmake-2.4.6";
  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = http://www.cmake.org/files/v2.4/cmake-2.4.6.tar.gz;
    sha256 = "0163q13gw9ff28dpbwq23h83qfqabvcxrzsi9cjpyc9dfg7jpf5g";
  };

  buildInputs = [];

  preConfigure="find Modules -type f -name '*.cmake' |
  xargs sed -e 's@/usr@/FOO@g' -e 's@ /\\(bin\\|sbin\\|lib\\)@ /FOO@g' -i";

  postInstall="find \$out/share -type f -name '*.cmake' |
  xargs sed -e 's@/usr@/FOO@g' -e 's@ /\\(bin\\|sbin\\|lib\\)@ /FOO@g' -i;
  ensureDir \$out/nix-support;
  cp -p $setupHook \$out/nix-support/setup-hook";

  meta = {
    description = "Cross-Platform Makefile Generator";
  };
}
