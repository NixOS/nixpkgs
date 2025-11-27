{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  pytestCheckHook,
  libxcrypt,
  gtest,
  pybind11,
  nlohmann_json,
  setuptools,
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
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avast";
    repo = "yaramod";
    tag = "v${version}";
    hash = "sha256-iIPMwN/kHrbN3ca+IJdyIfvrsnwiiflQY/gHAT3p+S4=";
  };

  postPatch = ''
    rm -r deps/googletest deps/pog/ deps/pybind11/ deps/json/json.hpp
    cp -r --no-preserve=all ${pog} deps/pog/
    cp -r --no-preserve=all ${nlohmann_json.src}/single_include/nlohmann/json.hpp deps/json/
    cp -r --no-preserve=all ${pybind11.src} deps/pybind11/
    cp -r --no-preserve=all ${gtest.src} deps/googletest/

    substituteInPlace deps/pog/deps/fmt/fmt/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  dontUseCmakeConfigure = true;

  buildInputs = [ libxcrypt ];

  nativeBuildInputs = [
    cmake
    pog
  ];

  build-system = [ setuptools ];

  env.ENV_YARAMOD_BUILD_WITH_UNIT_TESTS = true;

  nativeCheckInputs = [
    gtest
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/" ];

  pythonImportsCheck = [ "yaramod" ];

  meta = with lib; {
    description = "Parsing of YARA rules into AST and building new rulesets in C++";
    homepage = "https://github.com/avast/yaramod";
    changelog = "https://github.com/avast/yaramod/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ msm ];
  };
}
