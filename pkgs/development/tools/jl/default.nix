{ mkDerivation, fetchFromGitHub, fetchpatch
, aeson, aeson-pretty, attoparsec, base, bytestring, conduit, conduit-extra
, containers, exceptions, mtl, optparse-simple, parsec, scientific, lib
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
  patches = [
    # MonadFail compatibility patch. Should be removed with the next release
    (fetchpatch {
      url = "https://github.com/chrisdone/jl/commit/6d40308811cbc22a96b47ebe69ec308b4e9fd356.patch";
      sha256 = "1pg92ffkg8kim5r8rz8js6fjqyjisg1266sf7p9jyxjgsskwpa4g";
    })
  ];

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
