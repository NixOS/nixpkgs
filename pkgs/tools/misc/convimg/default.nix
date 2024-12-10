{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "convimg";
  version = "9.3";

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xnfMHlbQ7XG/mvnWoGkRHhxIK2u7kWJTVnLxd9c5oNU=";
    fetchSubmodules = true;
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convimg $out/bin/convimg
  '';

  meta = with lib; {
    description = "Image palette quantization";
    longDescription = ''
      This program is used to convert images to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convimg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
    mainProgram = "convimg";
  };
}
