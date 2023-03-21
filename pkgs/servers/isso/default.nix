{ lib
, fetchFromGitHub
, buildNpmPackage
, nixosTests

, buildPythonApplication
, bleach
, cffi
, flask-caching
, html5lib
, itsdangerous
, jinja2
, misaka
, pytest
, pytest-cov
, werkzeug }:
buildPythonApplication rec {
  pname = "isso";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kZNf7Rlb1DZtQe4dK1B283OkzQQcCX+pbvZzfL65gsA=";
  };

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
  ];

  preBuild = let
    frontend = buildNpmPackage {
      inherit version src;
      pname = "isso-frontend";

      npmDepsHash = "sha256-RBpuhFI0hdi8bB48Pks9Ac/UdcQ/DJw+WFnNj5f7IYE=";

      npmBuildScript = "build-prod";

      installPhase = ''
        cp -R isso/js/. $out/
      '';
    };
  in ''
    cp -R ${frontend}/. isso/js/
  '';

  nativeCheckInputs = [
    pytest
    pytest-cov
  ];

  checkPhase = ''
    pytest
  '';

  passthru.tests = { inherit (nixosTests) isso; };

  meta = with lib; {
    description = "A commenting server similar to Disqus";
    homepage = "https://posativ.org/isso/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
