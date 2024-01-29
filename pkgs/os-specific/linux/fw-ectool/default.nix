{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, hostname
}:

stdenv.mkDerivation {
  pname = "fw-ectool";
  version = "unstable-2022-12-03";

  src = fetchFromGitHub {
    owner = "DHowett";
    repo = "fw-ectool";
    rev = "54c140399bbc3e6a3dce6c9f842727c4128367be";
    hash = "sha256-2teJFz4zcA+USpbVPXMEIHLdmMLem8ik7YrmrSxr/n0=";
  };

  nativeBuildInputs = [
    pkg-config
    hostname
  ];

  buildPhase = ''
    patchShebangs util
    make out=out utils
  '';

  installPhase = ''
    install -D out/util/ectool $out/bin/ectool
  '';

  meta = with lib; {
    description = "EC-Tool adjusted for usage with framework embedded controller";
    homepage = "https://github.com/DHowett/framework-ec";
    license = licenses.bsd3;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.linux;
    mainProgram = "ectool";
  };
}
