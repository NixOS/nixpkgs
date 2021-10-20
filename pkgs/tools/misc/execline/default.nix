{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "execline";
  version = "2.8.1.0";
  sha256 = "0msmzf5zwjcsgjlvvq28rd2i0fkdb2skmv8ii0ix8dhyckwwjmav";

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

    # A wrapper around execlineb, which provides all execline
    # tools on `execlineb`’s PATH.
    # It is implemented as a C script, because on non-Linux,
    # nested shebang lines are not supported.
    # The -lskarnet has to come at the end to support static builds.
    $CC \
      -O \
      -Wall -Wpedantic \
      -D "EXECLINEB_PATH()=\"$bin/bin/.execlineb-wrapped\"" \
      -D "EXECLINE_BIN_PATH()=\"$bin/bin\"" \
      -I "${skalibs.dev}/include" \
      -L "${skalibs.lib}/lib" \
      -o "$bin/bin/execlineb" \
      ${./execlineb-wrapper.c} \
      -lskarnet
  '';
}
