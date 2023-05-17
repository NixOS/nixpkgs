{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "nlohmann_json";
  version = "3.7.3";
  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${version}";
    hash = "sha256-PNH+swMdjrh53Ioz2D8KuERKFpKM+iBf+eHo+HvwORM=";
  };
  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DBuildTests=OFF"
    "-DJSON_MultipleHeaders=ON"
  ];
  doCheck = false;
  postInstall = "rm -rf $out/lib64";
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.all;
  };
}
