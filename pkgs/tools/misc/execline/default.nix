{ lib, skawarePackages
# for execlineb-with-builtins
, coreutils, gnugrep, writeScriptBin, runCommand, runCommandCC
}:

with skawarePackages;

buildPackage {
  pname = "execline";
  version = "2.5.3.0";
  sha256 = "0czdrv9m8mnx94nf28dafij6z03k4mbhbs6hccfaardfd5l5q805";

  description = "A small scripting language, to be used in place of a shell in non-interactive scripts";

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  # TODO: nsss support
  configureFlags = [
    "--libdir=\${lib}/lib"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all execline executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libexecline.*

    mv doc $doc/share/doc/execline/html
    mv examples $doc/share/doc/execline/examples

    mv $bin/bin/execlineb $bin/bin/.execlineb-wrapped
    cc \
      -O \
      -Wall -Wpedantic \
      -D "EXECLINEB_PATH()=\"$bin/bin/.execlineb-wrapped\"" \
      -D "EXECLINE_BIN_PATH()=\"$bin/bin\"" \
      -I "${skalibs.dev}/include" \
      -L "${skalibs.lib}/lib" \
      -lskarnet \
      -o "$bin/bin/execlineb" \
      ${./execlineb-wrapper.c}
  '';
}
