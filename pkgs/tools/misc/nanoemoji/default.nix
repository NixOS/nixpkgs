{ lib
, python3
, fetchFromGitHub
, resvg
, pngquant
}:
python3.pkgs.buildPythonApplication rec {
  pname = "nanoemoji";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P/lT0PnjTdYzyttICzszu4OL5kj+X8GHZ8doL3tpXQM=";
  };
  patches = [
    # this is necessary because the tests clear PATH/PYTHONPATH otherwise
    ./test-pythonpath.patch
    # minor difference in the test output, most likely due to different dependency versions
    ./fix-test.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    pythonRelaxDepsHook

    pngquant
    resvg
  ];

  # these two packages are just prebuilt wheels containing the respective binaries
  pythonRemoveDeps = [ "pngquant-cli" "resvg-cli" ];

  propagatedBuildInputs = with python3.pkgs; [
    absl-py
    fonttools
    lxml
    ninja
    picosvg
    pillow
    regex
    toml
    tomlkit
    ufo2ft
    ufolib2
    zopfli
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook

    ninja
    picosvg
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ pngquant resvg ]}"
  ];

  preCheck = ''
    # make sure the built binaries (nanoemoji/maximum_color) can be found by the test
    export PATH="$out/bin:$PATH"
  '';

  meta = with lib; {
    description = "A wee tool to build color fonts";
    homepage = "https://github.com/googlefonts/nanoemoji";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle ];
  };
}
