{ stdenv, python3Packages, fetchFromGitHub, fetchpatch, glibcLocales, rustPlatform, pkgconfig, openssl, Security }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
python3Packages.buildPythonApplication rec {
  version = "unstable-2018-08-05";
  pname = "vdirsyncer";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "ac45cf144b0ceb72cc2a9f454808688f3ac9ba4f";
    sha256 = "0hqsjdpgvm7d34q5b2hzmrzfxk43ald1bx22mvgg559kw1ck54s9";
  };

  native = rustPlatform.buildRustPackage {
    name = "${name}-native";
    inherit src;
    sourceRoot = "source/rust";
    cargoSha256 = "02fxxw4vr6rpdbslrc9c1zhzs704bw7i40akrmh5cxl26rsffdgk";
    buildInputs = [ pkgconfig openssl ] ++ stdenv.lib.optional stdenv.isDarwin Security;
  };

  propagatedBuildInputs = with python3Packages; [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
    milksnake
    shippai
  ];

  buildInputs = with python3Packages; [ setuptools_scm ];

  checkInputs = with python3Packages; [ hypothesis pytest pytest-localserver pytest-subtesthack ] ++ [ glibcLocales ];

  patches = [
    # Fixes for hypothesis: https://github.com/pimutils/vdirsyncer/pull/779
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
    # for setuptools_scm:
    echo 'Version: ${version}' >PKG-INFO

    sed -i 's/spec.add_external_build(cmd=cmd/spec.add_external_build(cmd="true"/g' setup.py
  '';

  preBuild = ''
    mkdir -p rust/target/release
    ln -s ${native}/lib/libvdirsyncer_rustext* rust/target/release/
  '';

  LC_ALL = "en_US.utf8";

  checkPhase = ''
    rm -rf vdirsyncer
    export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
    make DETERMINISTIC_TESTS=true test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pimutils/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
