{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  libtool,
  readline,
  mkTclDerivation,
  tk,
}:

mkTclDerivation rec {
  pname = "tclreadline";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclreadline";
    tag = "v${version}";
    hash = "sha256-6FIQJsAm28jPIfNG+7xsMlCJSLw9JStOVzDemw2P+EI=";
  };

  nativeBuildInputs = [
    automake
    autoconf
    libtool
  ];
  buildInputs = [
    readline
    tk
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--enable-tclshrl"
    "--enable-wishrl"
    "--with-tk=${tk}/lib"
    "--with-readline-includes=${readline.dev}/include/readline"
    "--with-libtool=${libtool}"
  ];

  # The provided makefile leaves a wrong reference to /build/ in RPATH,
  # so we fix it after checking that everything is also present in $out
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    needed_libraries=$(ls .libs | grep '\.\(so\|la\)$')
    for lib in $needed_libraries; do
      if ! ls $out/lib | grep "$lib"; then
        echo "$lib was not installed correctly"
        exit 1
      fi
    done
    for executable in $out/bin/{wishrl,tclshrl}; do
      patchelf --set-rpath \
        "$(patchelf --print-rpath "$executable" | sed "s@$builddir/.libs@$out/lib@")" \
        "$executable"
    done
  '';

  meta = {
    description = "GNU readline for interactive tcl shells";
    homepage = "https://github.com/flightaware/tclreadline";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
