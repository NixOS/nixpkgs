{ lib, stdenv, fetchFromGitHub, makeWrapper, python3Packages, perl, zip
, gitMinimal, ffmpeg }:

let

  inherit (python3Packages)
    python pytest nose cryptography pyyaml requests mock requests-mock
    python-dateutil setuptools;

in stdenv.mkDerivation rec {
  pname = "svtplay-dl";
  version = "4.7";

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
    sha256 = "19ajm4bf7knnchggfbajx0c29q4sj8ffsvqmgizgsjdz48ppx2yf";
  };

  pythonPaths = [ cryptography pyyaml requests ];
  buildInputs = [ python perl python-dateutil setuptools ] ++ pythonPaths;
  nativeBuildInputs = [ gitMinimal zip makeWrapper ];
  checkInputs = [ nose pytest mock requests-mock ];

  postPatch = ''
    substituteInPlace scripts/run-tests.sh \
      --replace 'PYTHONPATH=lib' 'PYTHONPATH=lib:$PYTHONPATH'

    sed -i '/def test_sublang2\?(/ i\    @unittest.skip("accesses network")' \
      lib/svtplay_dl/tests/test_postprocess.py
  '';

  makeFlags = [ "PREFIX=$(out)" "SYSCONFDIR=$(out)/etc" "PYTHON=${python.interpreter}" ];

  postInstall = ''
    wrapProgram "$out/bin/svtplay-dl" \
      --prefix PATH : "${ffmpeg}" \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  doCheck = true;
  checkPhase = ''
    sh scripts/run-tests.sh -2
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/svtplay-dl --help > /dev/null
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/spaam/svtplay-dl";
    description = "Command-line tool to download videos from svtplay.se and other sites";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
}
