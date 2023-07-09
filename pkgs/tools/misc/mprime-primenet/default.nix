{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, gmp
}:

# This package provides patched versions of release builds instead of building
# from source because mprime can only be used to run workers for primenet
# using the official mprime release builds. Binaries of mprime built from
# source are only capable of local operation.

with (
  {
    # checksums for tarballs listed at https://www.mersenne.org/download/
    x86_64-linux = {
      version = "30.8b17";
      target = "linux64";
      sha256 = "5180c3843d2b5a7c7de4aa5393c13171b0e0709e377c01ca44154608f498bec7";
    };
    x86_64-darwin = {
      version = "30.8b15";
      target = "MacOSX";
      sha256 = "3a87122db12395c880f370796e8958776d7b8bd2ca07af68fe2e4520e8df68fd";
    };
  }."${stdenv.hostPlatform.system}"
);

let

  tarballName = "p95v${lib.replaceStrings ["."] [""] version}.${target}.tar.gz";

  tarball = fetchurl {
    url = "https://www.mersenne.org/download/software/v30/30.8/${tarballName}";
    inherit sha256;
  };

in

stdenv.mkDerivation {
  pname = "mprime-primenet";
  inherit version;

  # src handled in non-standard way to allow for the hashes for fetchurl of the
  # tarballs to match the checksums published on mersenne.org
  src = tarball;
  unpackPhase = ''
    cp $src $(echo $src | cut --delimiter=- --fields=2-)
  '';

  nativeBuildInputs =
    lib.optionals stdenv.isLinux [ autoPatchelfHook ]
  ;

  buildInputs = [ stdenv.cc.cc.lib gmp ];

  buildPhase = ''
    tar -xf ${tarballName}
  '';

  installPhase = ''
    install -m755 -D mprime $out/bin/mprime
  '';

  meta = with lib; {
    description = "Mersenne prime search / System stability tester";
    longDescription = ''
      MPrime is the Linux command-line interface version of Prime95, to be run
      in a text terminal or in a terminal emulator window as a remote shell
      client. It is identical to Prime95 in functionality, except it lacks a
      graphical user interface.
    '';
    homepage = "https://www.mersenne.org/";
    # Unfree, because of a license requirement to share prize money if you find
    # a suitable prime. http://www.mersenne.org/legal/#EULA
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ cameronfyfe ];
  };
}
