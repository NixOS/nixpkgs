{ lib, stdenv, fetchFromGitHub, makeWrapper, python3Packages, perl, zip
, gitMinimal, ffmpeg }:

let

  inherit (python3Packages)
    python pytest nose cryptography pyyaml requests mock python-dateutil setuptools;

in stdenv.mkDerivation rec {
  pname = "svtplay-dl";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
    sha256 = "01q03v6a2rkw49z5nbm5mghm0qmmm12pq3amsiiiv5j6m9p0fdsy";
  };

  pythonPaths = [ cryptography pyyaml requests ];
  buildInputs = [ python perl mock python-dateutil setuptools ] ++ pythonPaths;
  nativeBuildInputs = [ gitMinimal zip makeWrapper ];
  checkInputs = [ nose pytest ];

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

  meta = with lib; {
    homepage = "https://github.com/spaam/svtplay-dl";
    description = "Command-line tool to download videos from svtplay.se and other sites";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
}
