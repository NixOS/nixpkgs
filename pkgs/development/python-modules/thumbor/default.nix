{ buildPythonPackage, stdenv, tornado, pycrypto, pycurl, pytz
, pillow, derpconf, python_magic, pexif, libthumbor, opencv, webcolors
, piexif, futures, statsd, thumborPexif, fetchPypi, fetchpatch, isPy3k, lib
}:

buildPythonPackage rec {
  pname = "thumbor";
  version = "6.4.2";

  disabled = isPy3k; # see https://github.com/thumbor/thumbor/issues/1004

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y9mf78j80vjh4y0xvgnybc1wqfcwm5s19xhsfgkn12hh8pmh14d";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/thumbor/thumbor/commit/4f2bc99451409e404f7fa0f3e4a3bdaea7b49869.patch";
      sha256 = "0qqw1n1pfd8f8cn168718gzwf4b35j2j9ajyw643xpf92s0iq2cc";
    })
  ];

  postPatch = ''
    substituteInPlace "setup.py" \
      --replace '"argparse",' "" ${lib.optionalString isPy3k ''--replace '"futures",' ""''}
  '';

  propagatedBuildInputs = [
    tornado
    pycrypto
    pycurl
    pytz
    pillow
    derpconf
    python_magic
    pexif
    libthumbor
    opencv
    webcolors
    piexif
    statsd
  ] ++ lib.optionals (!isPy3k) [ futures thumborPexif ];

  # disabled due to too many impure tests and issues with native modules in
  # the pure testing environment. See https://github.com/NixOS/nixpkgs/pull/37147
  # for further reference.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A smart imaging service";
    homepage = https://github.com/thumbor/thumbor/wiki;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
