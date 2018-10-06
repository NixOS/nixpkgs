{ stdenv, python3Packages, glibcLocales, rustPlatform, pkgconfig, openssl }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
let
  pythonPackages = python3Packages;
  version = "0.17.0a3";
  pname = "vdirsyncer";
  name = pname + "-" + version;
  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1n7izfa5x9mh0b4zp20gd8qxfcca5wpjh834bsbi5pk6zam5pfdy";
  };
  native = rustPlatform.buildRustPackage {
    name = name + "-native";
    inherit src;
    sourceRoot = name + "/rust";
    cargoSha256 = "08xq9q5fx37azzkqqgwcnds1yd8687gh26dsl3ivql5h13fa2w3q";
    buildInputs = [ pkgconfig openssl ];
  };
in pythonPackages.buildPythonApplication rec {
  inherit version pname src native;

  propagatedBuildInputs = with pythonPackages; [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
    milksnake
    shippai
  ];

  buildInputs = with pythonPackages; [ setuptools_scm ];

  checkInputs = with pythonPackages; [ hypothesis pytest pytest-localserver pytest-subtesthack ] ++ [ glibcLocales ];

  postPatch = ''
    sed -i 's/spec.add_external_build(cmd=cmd/spec.add_external_build(cmd="true"/g' setup.py
  '';

  preBuild = ''
    mkdir -p rust/target/release
    ln -s ${native}/lib/libvdirsyncer_rustext* rust/target/release/
  '';

  LC_ALL = "en_US.utf8";

  checkPhase = ''
    rm -rf vdirsyncer
    export PYTHONPATH=$out/${pythonPackages.python.sitePackages}:$PYTHONPATH
    make DETERMINISTIC_TESTS=true test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pimutils/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
