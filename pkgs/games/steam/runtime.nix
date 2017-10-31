{ stdenv, steamArch, fetchurl, writeText, python2, dpkg, binutils }:

let input = builtins.getAttr steamArch (import ./runtime-generated.nix { inherit fetchurl; });

    inputFile = writeText "steam-runtime.json" (builtins.toJSON input);

in stdenv.mkDerivation {
  name = "steam-runtime-2016-08-13";

  nativeBuildInputs = [ python2 dpkg binutils ];

  buildCommand = ''
    mkdir -p $out
    python2 ${./build-runtime.py} -i ${inputFile} -r $out
  '';

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = https://github.com/ValveSoftware/steam-runtime;
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
