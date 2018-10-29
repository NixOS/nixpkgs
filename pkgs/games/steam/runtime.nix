{ stdenv, steamArch, fetchurl, writeText, python2, dpkg }:

let
  generated = stdenv.lib.importJSON ./runtime-generated.json;
  input = map (x: with x; {
      inherit name;
      source = fetchurl {
        inherit sha256;
        url = "mirror://steamrt/" + path;
        name = shortName;
      };
  }) (builtins.getAttr steamArch generated);

  inputFile = writeText "steam-runtime.json" (builtins.toJSON input);
  version = generated.date;

in stdenv.mkDerivation {
  inherit version;
  name = "steam-runtime-${version}";

  nativeBuildInputs = [ python2 dpkg stdenv.cc.bintools ];

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
