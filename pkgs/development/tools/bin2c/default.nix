{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linux,
}:

stdenv.mkDerivation {
  pname = "bin2c";
  version = "unstable-2020-05-30";

  src = fetchFromGitHub {
    owner = "adobe";
    repo = "bin2c";
    rev = "4300880a350679a808dc05bdc2840368f5c24d9a";
    sha256 = "sha256-PLo5kkN2k3KutVGumoXEB2x9MdxDUtpwAQZLwm4dDvw=";
  };

  makeFlags = [ "prefix=$(out)" ];

  doCheck = !stdenv.isDarwin;
  checkTarget = "test";
  checkInputs = [ util-linux ]; # uuidgen

  meta = with lib; {
    description = "Embed binary & text files inside C binaries";
    mainProgram = "bin2c";
    homepage = "https://github.com/adobe/bin2c";
    license = licenses.asl20;
    maintainers = [ maintainers.shadowrz ];
    platforms = platforms.all;
  };
}
