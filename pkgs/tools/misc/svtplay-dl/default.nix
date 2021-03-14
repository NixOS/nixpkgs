{ lib, stdenv, fetchFromGitHub, makeWrapper, python3Packages, perl, zip
, gitMinimal, ffmpeg }:

let

  inherit (python3Packages)
    python nose pycrypto pyyaml requests mock python-dateutil setuptools;

in stdenv.mkDerivation rec {
  pname = "svtplay-dl";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "spaam";
    repo = "svtplay-dl";
    rev = version;
    sha256 = "1k7829sgvs2ihnf8d3zrqk99ifm9867wcn6f8zg628h8aqsif4fc";
  };

  pythonPaths = [ pycrypto pyyaml requests ];
  buildInputs = [ python perl nose mock python-dateutil setuptools ] ++ pythonPaths;
  nativeBuildInputs = [ gitMinimal zip makeWrapper ];

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
    maintainers = [ maintainers.rycee ];
  };
}
