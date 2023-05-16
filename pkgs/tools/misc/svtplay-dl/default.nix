{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, python3Packages
, perl
, zip
, gitMinimal
, ffmpeg
}:

let

  inherit (python3Packages)
    python pytest nose cryptography pyyaml requests mock requests-mock
    python-dateutil setuptools;

<<<<<<< HEAD
  version = "4.25";
=======
  version = "4.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

in

stdenv.mkDerivation rec {
  pname = "svtplay-dl";
  inherit version;

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-vYcBK7jgoBEC7dZ+5osJ/Q85wSNLXO02wcv9GHaa0Ds=";
=======
    hash = "sha256-nG4ErqQC7GZDLClqcE3cliXxowzCku/SnB39AVIqkNw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonPaths = [ cryptography pyyaml requests ];
  buildInputs = [ python perl python-dateutil setuptools ] ++ pythonPaths;
  nativeBuildInputs = [ gitMinimal zip makeWrapper ];
  nativeCheckInputs = [ nose pytest mock requests-mock ];

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
