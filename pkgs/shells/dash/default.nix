{ lib
, stdenv
, buildPackages
, pkg-config
, fetchurl
, libedit
, runCommand
, dash
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "dash";
  version = "0.5.12";

  src = fetchurl {
<<<<<<< HEAD
    url = "http://gondor.apana.org.au/~herbert/dash/files/dash-${finalAttrs.version}.tar.gz";
    hash = "sha256-akdKxG6LCzKRbExg32lMggWNMpfYs4W3RQgDDKSo8oo=";
=======
    url = "http://gondor.apana.org.au/~herbert/dash/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-akdKxG6LCzKRbExg32lMggWNMpfYs4W3RQgDDKSo8oo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru = {
    shellPath = "/bin/dash";
    tests = {
      "execute-simple-command" = runCommand "dash-execute-simple-command" { } ''
        mkdir $out
        ${lib.getExe dash} -c 'echo "Hello World!" > $out/success'
        [ -s $out/success ]
        grep -q "Hello World" $out/success
      '';
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
<<<<<<< HEAD
    mainProgram = "dash";
  };
})
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
