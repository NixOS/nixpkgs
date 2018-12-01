{ stdenv, python3Packages, fetchpatch, glibcLocales, rustPlatform, pkgconfig, openssl, Security }:

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
    buildInputs = [ pkgconfig openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;
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

  patches = [
    (fetchpatch {
      url = https://github.com/pimutils/vdirsyncer/commit/80a42e4c6c18ca4db737bc6700c50a3866832bbb.patch;
      sha256 = "1vrhn0ma3y08w6f5abhl3r5rq30g60h1bp3wmyszw909hyvyzp5l";
    })
    (fetchpatch {
      url = https://github.com/pimutils/vdirsyncer/commit/22ad88a6b18b0979c5d1f1d610c1d2f8f87f4b89.patch;
      sha256 = "0dbzj6jlxhdidnm3i21a758z83sdiwzhpd45pbkhycfhgmqmhjpl";
    })
    (fetchpatch {
      url = https://github.com/pimutils/vdirsyncer/commit/29417235321c249c65904bc7948b066ef5683aee.patch;
      sha256 = "0zvr0y88gm3vprjcdzs4m151laa9qhkyi61rvrfdjmf42fwhbm80";
    })
  ];

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
