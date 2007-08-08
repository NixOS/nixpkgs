{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "cmake-2.4.7";
  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = http://www.cmake.org/files/v2.4/cmake-2.4.7.tar.gz;
    sha256 = "0mkx23s7zq48hzzzw3vbzsfzfz3rjsiwgf3i00xawcxrjjrgxm9g";
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
