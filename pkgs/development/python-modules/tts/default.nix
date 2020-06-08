{ lib, pkgs, buildPythonPackage, python3Packages, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "tts";
  version = "unstable-2020-06-11";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "TTS";
    rev = "7e799d58d6b8e7c56967c54f6f45c7b3d599a660";
    sha256 = "1xxi5n4j7xdxqmahf4vr287bblbr00dbpxmhmqg2rm1vxb9zq54r";
  };

  patches = [
    ./loosen-deps.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    matplotlib
    scipy
    pytorch
    flask
    attrdict
    bokeh
    soundfile
    tqdm
    librosa
    unidecode
  ] ++ (with pkgs; [ 
    phonemizer
    tensorboardx
  ]);

  preBuild = ''
    export HOME=$TMPDIR
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/TTS";
    description = "Deep learning for Text to Speech";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa ];
  };
}
