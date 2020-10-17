{ lib, stdenv, callPackage, python3Packages, fetchFromGitLab, cacert,
  rustPlatform, bubblewrap, git, perlPackages, imagemagick7, fetchurl, fetchzip,
  jre, makeWrapper, tr-patcher, tes3cmd }:

let
  version = "2.0_beta9";

  src = fetchFromGitLab {
    owner = "portmod";
    repo = "Portmod";
    rev = "v${version}";
    sha256 = "0a598rb0z6gsdyr4n0lc0yc583njjii07p6vxw75xsh7292vxksc";
  };

  portmod-rust = rustPlatform.buildRustPackage rec {
    inherit src version;
    pname = "portmod-rust";

    cargoSha256 = "14p1aywwbkf2pk85sir5g9ni08zam2hid0kaz111718b006nrxh7";

    nativeBuildInputs = [ python3Packages.python ];

    doCheck = false;
  };

  bin-programs = [
    bubblewrap
    git
    python3Packages.virtualenv
    tr-patcher
    tes3cmd
    imagemagick7
  ];

in
python3Packages.buildPythonApplication rec {
  inherit src version;

  pname = "portmod";

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # build the rust library independantly
  prePatch = ''
    substituteInPlace setup.py \
      --replace "from setuptools_rust import Binding, RustExtension" "" \
      --replace "RustExtension(\"portmod.portmod\", binding=Binding.PyO3, strip=True)" ""
  '';

  propagatedBuildInputs = with python3Packages; [
    setuptools_scm
    setuptools
    requests
    chardet
    colorama
    restrictedpython
    appdirs
    GitPython
    progressbar2
    python-sat
    redbaron
    patool
    packaging
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ] ++ bin-programs;

  preCheck = ''
    cp ${portmod-rust}/lib/libportmod.so portmod/portmod.so
    export HOME=$(mktemp -d)
  '';

  # some test require network access
  disabledTests = [
    "test_masters_esp"
    "test_logging"
    "test_execute_network_permissions"
    "test_execute_permissions_bleed"
    "test_git"
  ];

  # for some reason, installPhase doesn't copy the compiled binary
  postInstall = ''
    cp ${portmod-rust}/lib/libportmod.so $out/${python3Packages.python.sitePackages}/portmod/portmod.so

    makeWrapperArgs+=("--prefix" "GIT_SSL_CAINFO" ":" "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      "--prefix" "PATH" ":" "${lib.makeBinPath bin-programs }")
  '';

  meta = {
    description = "mod manager for openMW based on portage";
    homepage = "https://gitlab.com/portmod/portmod";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
