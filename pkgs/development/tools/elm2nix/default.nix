{ mkDerivation, aeson, ansi-wl-pprint, async, base, binary
, bytestring, containers, data-default, directory, filepath, here
, mtl, optparse-applicative, process, req, stdenv, text
, transformers, unordered-containers
}:
mkDerivation {
  pname = "elm2nix";
  version = "0.1.0";
  sha256 = "9ec1f1f694a38b466ebd03aaa1a035bbdb9bdae390be5b9a030611bcbfd91890";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base binary bytestring containers data-default
    directory filepath here mtl process req text transformers
    unordered-containers
  ];
  executableHaskellDepends = [
    ansi-wl-pprint base directory here optparse-applicative
  ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/domenkozar/elm2nix#readme";
  description = "Turn your Elm project into buildable Nix project";
  license = stdenv.lib.licenses.bsd3;
}
