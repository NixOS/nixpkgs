{ lib, stdenv, fetchFromGitHub, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "mbusd";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "3cky";
    repo = "mbusd";
    rev = "v${version}";
    hash = "sha256-vYYaJKcnREng+2UsDIZ28hvANkQCHVixQIxo82m7MQs=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "Modbus TCP to Modbus RTU (RS-232/485) gateway";
    homepage = "https://github.com/3cky/mbusd";
    changelog = "https://github.com/3cky/mbusd/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
