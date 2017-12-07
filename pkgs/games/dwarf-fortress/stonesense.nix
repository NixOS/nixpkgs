{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "stonesense";
  src = fetchFromGitHub {
    owner = "DFHack";
    repo = "stonesense";
    rev = "be793a080e66db1ff79ac284070632ec1a896708";
    sha256 = "1kibqblxp16z75zm48kk59w483933rkg4w339f28fcrbpg4sn92s";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DDFHACK_BUILD_ARCH=64" ];
}
