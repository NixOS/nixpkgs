{ lib
, stdenv
, buildPackages
, pkg-config
, fetchurl
, libedit
, runCommand
, dash
}:

stdenv.mkDerivation rec {
  pname = "dash";
  version = "0.5.12";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-akdKxG6LCzKRbExg32lMggWNMpfYs4W3RQgDDKSo8oo=";
  };

  strictDeps = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isStatic [ pkg-config ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = [ libedit ];

  configureFlags = [ "--with-libedit" ];
  preConfigure = lib.optional stdenv.hostPlatform.isStatic ''
    export LIBS="$(''${PKG_CONFIG:-pkg-config} --libs --static libedit)"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
  };

  passthru = {
    shellPath = "/bin/dash";
    tests = {
      "execute-simple-command" = runCommand "${pname}-execute-simple-command" { } ''
        mkdir $out
        ${dash}/bin/dash -c 'echo "Hello World!" > $out/success'
        [ -s $out/success ]
        grep -q "Hello World" $out/success
      '';
    };
  };
}
