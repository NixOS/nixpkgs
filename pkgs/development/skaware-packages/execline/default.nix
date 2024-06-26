{
  lib,
  skawarePackages,
  skalibs,
}:

let
  version = "2.9.6.0";

in
skawarePackages.buildPackage {
  inherit version;

  pname = "execline";
  # ATTN: also check whether there is a new manpages version
  sha256 = "uion6Xxetr18pqCYeokl5ERlpb6ZbaoNGPj+yjfXVxo=";

  # Maintainer of manpages uses following versioning scheme: for every
  # upstream $version he tags manpages release as ${version}.1, and,
  # in case of extra fixes to manpages, new tags in form ${version}.2,
  # ${version}.3 and so on are created.
  manpages = skawarePackages.buildManPages {
    pname = "execline-man-pages";
    version = "2.9.6.0.1";
    sha256 = "0lyX3rIUZ2JqWioRSm22uDS+q9ONkwIZxfR5E2pSDC4=";
    description = "Port of the documentation for the execline suite to mdoc";
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  description = "Small scripting language, to be used in place of a shell in non-interactive scripts";

  outputs = [
    "bin"
    "lib"
    "dev"
    "doc"
    "out"
  ];

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
