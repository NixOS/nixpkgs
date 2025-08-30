{
  pkgs,
  nodejs,
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
  fetchNpmDeps,
  npmHooks,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "isso";
  version = "0.13.1.dev0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    tag = version;
    sha256 = "sha256-8G10UiD5eAuuRce8wpdCpp+1xRd66dk+uWIFlcHddEI=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-rhPOUvWRZBc4r/pzy2D2KL4UuRBdbJTjGLHJrQfkZKs=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    # Remove when https://github.com/posativ/isso/pull/973 is available.
    substituteInPlace isso/tests/test_comments.py \
      --replace "self.client.delete_cookie('localhost.local', '1')" "self.client.delete_cookie(key='1', domain='localhost')"
  '';

  propagatedBuildInputs = [
    itsdangerous
    jinja2
    misaka
    html5lib
    werkzeug
    bleach
    flask-caching
  ];

  nativeBuildInputs = [
    cffi
    sphinxHook
    sphinx
    nodejs
    npmHooks.npmConfigHook
  ];

  NODE_PATH = "$npmDeps";

  preBuild = ''
    ln -s ${npmDeps}/node_modules ./node_modules
    export PATH="${npmDeps}/bin:$PATH"

    make js
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  passthru.tests = { inherit (nixosTests) isso; };

  meta = with lib; {
    description = "Commenting server similar to Disqus";
    mainProgram = "isso";
    homepage = "https://posativ.org/isso/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
