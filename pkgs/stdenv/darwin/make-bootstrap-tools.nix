{system ? builtins.currentSystem}:

with import ../../top-level/all-packages.nix {inherit system;};

rec {
  # We want coreutils without ACL support.
  coreutils_ = coreutils.override (orig: {
    aclSupport = false;
    stdenv = overrideInStdenv stdenv [ libiconv ];
  });

  diffutils_ = diffutils.override (orig: {
    stdenv = overrideInStdenv stdenv [ libiconv ];
  });

  gnutar_ = gnutar.override (orig: {
    stdenv = overrideInStdenv stdenv [ libiconv ];
  });

  bash_ = bash.override (orig: {
    stdenv = overrideInStdenv stdenv [ libiconv ];
  });

  curl = import ../../tools/networking/curl {
    inherit fetchurl;
    zlibSupport = false;
    sslSupport = false;
  };


  build = stdenv.mkDerivation {
    name = "build";

    buildInputs = [nukeReferences cpio];

    buildCommand = ''
      set -x
      mkdir -p $out/bin $out/lib $out/libexec

      # Copy coreutils, bash, etc.
      cp ${coreutils_}/bin/* $out/bin
      (cd $out/bin && rm vdir dir sha*sum pinky factor pathchk runcon shuf who whoami shred users)

      cp ${bash_}/bin/bash $out/bin
      cp ${findutils}/bin/find $out/bin
      cp ${findutils}/bin/xargs $out/bin
      cp -d ${diffutils_}/bin/* $out/bin
      cp -d ${gnused}/bin/* $out/bin
      cp -d ${gnugrep}/bin/* $out/bin
      cp ${gawk}/bin/gawk $out/bin
      cp -d ${gawk}/bin/awk $out/bin
      cp ${gnutar_}/bin/tar $out/bin
      cp ${gzip}/bin/gzip $out/bin
      cp ${bzip2}/bin/bzip2 $out/bin
      cp -d ${gnumake}/bin/* $out/bin
      cp -d ${patch}/bin/* $out/bin

      cp -d ${zlib}/lib/libz.* $out/lib
      cp -d ${gmpxx}/lib/libgmp*.* $out/lib

      # Copy binutils.

      chmod -R u+w $out

      # Strip executables even further.
      for i in $out/bin/* $out/libexec/gcc/*/*/*; do
        if test -x $i -a ! -L $i; then
          chmod +w $i
          strip -s $i || true
        fi
      done

      nuke-refs $out/bin/*
      nuke-refs $out/lib/*
      nuke-refs $out/libexec/gcc/*/*/*

      mkdir $out/.pack
      mv $out/* $out/.pack
      mv $out/.pack $out/pack

      mkdir $out/on-server
      (cd $out/pack && (find | cpio -o -H newc)) | bzip2 > $out/on-server/bootstrap-tools.cpio.bz2

      # mkdir $out/in-nixpkgs
      # chmod u+w $out/in-nixpkgs/*
      # strip $out/in-nixpkgs/*
      # nuke-refs $out/in-nixpkgs/*
      # bzip2 $out/in-nixpkgs/curl
    '';

    allowedReferences = [];
  };
}