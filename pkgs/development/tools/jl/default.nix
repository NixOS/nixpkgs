{ mkDerivation, fetchFromGitHub, fetchpatch
, aeson, aeson-pretty, attoparsec, base, bytestring, conduit, conduit-extra
, containers, exceptions, mtl, optparse-simple, parsec, scientific, lib
, text, unordered-containers, vector
}:
mkDerivation rec {
  pname = "jl";
  version = "0.1.0";
  sha256 = "15vvn3swjpc5qmdng1fcd8m9nif4qnjmpmxc9hdw5cswzl055lkj";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson attoparsec base bytestring containers exceptions mtl parsec
    scientific text unordered-containers vector
  ];
  executableHaskellDepends = [
    aeson aeson-pretty base bytestring conduit conduit-extra containers
    mtl optparse-simple text vector
  ];
  license = lib.licenses.bsd3;
  description = "Functional sed for JSON";
  maintainers = with lib.maintainers; [ fgaz ];
  homepage = "https://github.com/chrisdone/jl";
}
