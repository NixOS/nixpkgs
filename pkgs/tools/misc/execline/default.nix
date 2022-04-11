{ fetchFromGitHub, skawarePackages }:

with skawarePackages;
let
  version = "2.8.3.0";

  # Maintainer of manpages uses following versioning scheme: for every
  # upstream $version he tags manpages release as ${version}.1, and,
  # in case of extra fixes to manpages, new tags in form ${version}.2,
  # ${version}.3 and so on are created.
  manpages = fetchFromGitHub {
    owner = "flexibeast";
    repo = "execline-man-pages";
    rev = "v${version}.2";
    sha256 = "0fzv5as81aqgl8llbz8c5bk5n56iyh4g70r54wmj71rh2d1pihk5";
  };

in buildPackage {
  inherit version;

  pname = "execline";
  sha256 = "105dnkw1y6lz0ibqy5b4jarq31y40k7ymhl77i9f10jcb76vwp93";

  description = "A small scripting language, to be used in place of a shell in non-interactive scripts";

  outputs = [ "bin" "man" "lib" "dev" "doc" "out" ];

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
    mkdir -p $man/share/
    cp -vr ${manpages}/man* $man/share
  '';
}
