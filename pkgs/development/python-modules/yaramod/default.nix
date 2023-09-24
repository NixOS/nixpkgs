{ lib
, buildPythonPackage
, cmake
, fetchFromGitHub
, pytestCheckHook
, libxcrypt
, pythonOlder
, gtest
, pybind11
, nlohmann_json
}:

let
  pog = fetchFromGitHub {
    owner = "metthal";
    repo = "pog";
    rev = "b09bbf9cea573ee62aab7eccda896e37961d16cd";
    hash = "sha256-El4WA92t2O/L4wUqH6Xj8w+ANtb6liRwafDhqn8jxjQ=";
  };
in
  buildPythonPackage rec {
    pname = "yaramod";
    version = "3.20.2";
    format = "setuptools";

    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "avast";
      repo = pname;
      rev = "refs/tags/v${version}";
      hash = "sha256-OLsTvG+qaUJlKdHwswGBifzoT/uNunrrVWQg7hJxkhE=";
    };

    postPatch = ''
      rm -r deps/googletest deps/pog/ deps/pybind11/ deps/json/json.hpp
      cp -r --no-preserve=all ${pog} deps/pog/
      cp -r --no-preserve=all ${nlohmann_json.src}/single_include/nlohmann/json.hpp deps/json/
      cp -r --no-preserve=all ${pybind11.src} deps/pybind11/
      cp -r --no-preserve=all ${gtest.src} deps/googletest/
    '';

    dontUseCmakeConfigure = true;

    buildInputs = [
      libxcrypt
    ];

    nativeBuildInputs = [
      cmake
      pog
      gtest
    ];

    setupPyBuildFlags = [
      "--with-unit-tests"
    ];

    checkInputs = [
      pytestCheckHook
    ];

    pytestFlagsArray = [
      "tests/"
    ];

    pythonImportsCheck = [
      "yaramod"
    ];

    meta = with lib; {
      description = "Parsing of YARA rules into AST and building new rulesets in C++";
      homepage = "https://github.com/avast/yaramod";
      changelog = "https://github.com/avast/yaramod/blob/v${version}/CHANGELOG.md";
      license = licenses.mit;
      maintainers = with maintainers; [ msm ];
    };
  }
