{ buildPythonPackage, tornado, pycrypto, pycurl, pytz
, pillow, derpconf, python_magic, pexif, libthumbor, opencv, webcolors
, piexif, futures, statsd, thumborPexif, fetchPypi, isPy3k, lib
}:

buildPythonPackage rec {
  pname = "thumbor";
  version = "6.5.2";

  disabled = isPy3k; # see https://github.com/thumbor/thumbor/issues/1004

  src = fetchPypi {
    inherit pname version;
    sha256 = "1icfnzwzi5lvnh576n7v3r819jaw15ph9ja2w3fwg5z9qs40xvl8";
  };

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

  meta = with lib; {
    description = "A smart imaging service";
    homepage = https://github.com/thumbor/thumbor/wiki;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
