{ buildPythonPackage, python, tornado, pycrypto, pycurl, pytz
, pillow, derpconf, python_magic, libthumbor, webcolors
, piexif, futures, statsd, thumborPexif, fetchFromGitHub, isPy3k, lib
, mock, raven, nose, yanc, remotecv, pyssim, cairosvg1, preggy, opencv3
, pkgs, coreutils
}:

buildPythonPackage rec {
  pname = "thumbor";
  version = "6.6.0";

  disabled = isPy3k; # see https://github.com/thumbor/thumbor/issues/1004

  # Tests aren't included in PyPI tarball so use GitHub instead
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0m4q40fcha1aydyr1khjhnb08cdfma67yxgyhsvwar5a6sl0906i";
  };

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
    cairosvg1
    raven
    pkgs.redis
    pkgs.glibcLocales
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
    pkgs.exiftool
    pkgs.libjpeg
    pkgs.ffmpeg
    pkgs.gifsicle
  ] ++ lib.optionals (!isPy3k) [ futures thumborPexif ];

  # Remove the source tree before running nosetests because otherwise nosetests
  # uses that instead of the installed package. Is there some other way to
  # achieve this?
  checkPhase = ''
    redis-server --port 6668 --requirepass hey_you &
    rm -r thumbor
    export LC_ALL="en_US.UTF-8"
    nosetests -v --with-yanc -s tests/
  '';

  meta = with lib; {
    description = "A smart imaging service";
    homepage = https://github.com/thumbor/thumbor/wiki;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
