{ lib, stdenv, fetchFromGitLab, getopt, lua, boost, pkg-config, swig, perl, gcc }:

with lib;

let
  self = stdenv.mkDerivation rec {
    pname = "highlight";
    version = "3.60";

    src = fetchFromGitLab {
      owner = "saalen";
      repo = "highlight";
      rev = "v${version}";
      sha256 = "sha256-1EBdtORd9P5DJUmbZa9KjR3UUoHOKLbjqbxpFi5WFvQ=";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = [ pkg-config swig perl ] ++ optional stdenv.isDarwin gcc;

    buildInputs = [ getopt lua boost ];

    prePatch = lib.optionalString stdenv.cc.isClang ''
      substituteInPlace src/makefile \
          --replace 'CXX=g++' 'CXX=clang++'
    '';

    preConfigure = ''
      makeFlags="PREFIX=$out conf_dir=$out/etc/highlight/ CXX=$CXX AR=$AR"
    '';

    # This has to happen _before_ the main build because it does a
    # `make clean' for some reason.
    preBuild = optionalString (!stdenv.isDarwin) ''
      make -C extras/swig $makeFlags perl
    '';

    postCheck = optionalString (!stdenv.isDarwin) ''
      perl -Iextras/swig extras/swig/testmod.pl
    '';

    preInstall = optionalString (!stdenv.isDarwin) ''
      mkdir -p $out/${perl.libPrefix}
      install -m644 extras/swig/highlight.{so,pm} $out/${perl.libPrefix}
      make -C extras/swig clean # Clean up intermediate files.
    '';

    meta = with lib; {
      description = "Source code highlighting tool";
      homepage = "http://www.andre-simon.de/doku/highlight/en/highlight.php";
      platforms = platforms.unix;
      maintainers = with maintainers; [ willibutz ];
    };
  };

in
  if stdenv.isDarwin then self
  else perl.pkgs.toPerlModule self
