# rapidjson used in nixpkgs is too old. Although it is technically a latest release, it was made in 2016.
# Redpanda uses its own version
{ clangStdenv
, cmake
, fetchFromGitHub
, lib
, pkg-config
}:

clangStdenv.mkDerivation rec {
  pname = "rapidjson";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "rapidjson";
    rev = "27c3a8dc0e2c9218fe94986d249a12b5ed838f1d";
    sha256 = "sha256-wggyCL5uEsnJDxkYAUsXOjoO1MNQBGB05E6aSpsNcl0=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  doCheck = false;

  meta = with lib; {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    maintainers = with maintainers; [ avakhrenev ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
