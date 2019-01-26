{ mkDerivation, fetchFromGitHub
, aeson, aeson-pretty, attoparsec, base, bytestring, conduit, conduit-extra
, containers, exceptions, mtl, optparse-simple, parsec, scientific, stdenv
, text, unordered-containers, vector
}:
mkDerivation rec {
  pname = "jl";
  version = "0.0.5";
  src = fetchFromGitHub {
    owner = "chrisdone";
    repo = "jl";
    rev = "v${version}";
    sha256 = "1hlnwsl4cj0l4x8dxwda2fcnk789cwlphl9gv9cfrivl43mgkgar";
  };
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
  license = stdenv.lib.licenses.bsd3;
  description = "Functional sed for JSON";
  maintainers = with stdenv.lib.maintainers; [ fgaz ];
  homepage = https://github.com/chrisdone/jl;
}
