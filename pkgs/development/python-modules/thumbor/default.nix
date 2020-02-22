{ buildPythonPackage, python, tornado, pycrypto, pycurl, pytz
, pillow, derpconf, python_magic, libthumbor, webcolors
, piexif, futures, statsd, thumborPexif, fetchFromGitHub, isPy3k, lib
, mock, raven, nose, yanc, remotecv, pyssim, cairosvg, preggy, opencv3
, pkgs, coreutils, substituteAll
}:

buildPythonPackage rec {
  pname = "thumbor";
  version = "6.7.0";

  disabled = isPy3k; # see https://github.com/thumbor/thumbor/issues/1004

  # Tests aren't included in PyPI tarball so use GitHub instead
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1qv02jz7ivn38dsywp7nxrlflly86x9pm2pk3yqi8m8myhc7lipg";
  };

  patches = [
    (substituteAll {
      src = ./0001-Don-t-use-which-implementation-to-find-required-exec.patch;
      gifsicle = "${pkgs.gifsicle}/bin/gifsicle";
      exiftool = "${pkgs.exiftool}/bin/exiftool";
      jpegtran = "${pkgs.libjpeg}/bin/jpegtran";
      ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
    })
  ];

  postPatch = ''
    substituteInPlace "setup.py" \
      --replace '"argparse",' "" ${lib.optionalString isPy3k ''--replace '"futures",' ""''}
    sed -i setup.py \
        -e 's/piexif[^"]*/piexif/;s/Pillow[^"]*/Pillow/'
    substituteInPlace "tests/test_utils.py" \
      --replace "/bin/ls" "${coreutils}/bin/ls"
    substituteInPlace "tests/detectors/test_face_detector.py" \
      --replace "./thumbor" "$out/lib/${python.libPrefix}/site-packages/thumbor"
    substituteInPlace "tests/detectors/test_glasses_detector.py" \
      --replace "./thumbor" "$out/lib/${python.libPrefix}/site-packages/thumbor"
  '';

  checkInputs = [
    nose
    pyssim
    preggy
    mock
    yanc
    remotecv
    raven
    pkgs.redis
    pkgs.glibcLocales
    pkgs.gifsicle
  ];

  propagatedBuildInputs = [
    tornado
    pycrypto
    pycurl
    pytz
    pillow
    derpconf
    python_magic
    libthumbor
    opencv3
    webcolors
    piexif
    statsd
    cairosvg
  ] ++ lib.optionals (!isPy3k) [ futures thumborPexif ];

  # Remove the source tree before running nosetests because otherwise nosetests
  # uses that instead of the installed package. Is there some other way to
  # achieve this?
  checkPhase = ''
    redis-server --port 6668 --requirepass hey_you &
    rm -r thumbor
    export LC_ALL="en_US.UTF-8"
    nosetests -v --with-yanc -s tests/ -e test_redeye_applied
  '';

  meta = with lib; {
    description = "A smart imaging service";
    homepage = https://github.com/thumbor/thumbor/wiki;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
