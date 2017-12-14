{ stdenv, fetchurl, writeText, python2, dpkg, binutils }:

let arch = if stdenv.system == "x86_64-linux" then "amd64"
           else if stdenv.system == "i686-linux" then "i386"
           else throw "Unsupported platform";

    input = builtins.getAttr arch (import ./runtime-generated.nix { inherit fetchurl; });

    inputFile = writeText "steam-runtime.json" (builtins.toJSON input);

in stdenv.mkDerivation {
  name = "steam-runtime-2016-08-13";

  nativeBuildInputs = [ python2 dpkg binutils ];

  buildCommand = ''
    mkdir -p $out
    python2 ${./build-runtime.py} -i ${inputFile} -r $out
  '';

  passthru = rec {
    inherit arch;

    gnuArch = if arch == "amd64" then "x86_64-linux-gnu"
              else if arch == "i386" then "i386-linux-gnu"
              else abort "Unsupported architecture";

    libs = [ "lib/${gnuArch}" "lib" "usr/lib/${gnuArch}" "usr/lib" ];
    bins = [ "bin" "usr/bin" ];
  };

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = https://github.com/ValveSoftware/steam-runtime;
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
