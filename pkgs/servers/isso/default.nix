{ lib
, fetchFromGitHub
, fetchpatch
, python3
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "isso";
  version = "0.12.2";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = version;
    sha256 = "18v8lzwgl5hcbnawy50lfp3wnlc0rjhrnw9ja9260awkx7jra9ba";
  };

  # Some backports from master to fix the build with python 3 and newer libraries
  patches = [
    # https://github.com/jelmer/isso/commit/e2cfd6c08c0fbe64aedac22b17d30e7a8834cd5b
    (fetchpatch {
      name = "python-3.7-support";
      url = "https://github.com/jelmer/isso/commit/e2cfd6c08c0fbe64aedac22b17d30e7a8834cd5b.patch";
      sha256 = "0rgwv6d9q2zdrdkswzdz637xsfbz9405g9shydk7zjcz1km53s4q";
    })

    # https://github.com/posativ/isso/issues/611
    # https://github.com/posativ/isso/pull/614
    (fetchpatch {
      name = "werkzeug-1-compatibility";
      url = "https://github.com/posativ/isso/pull/614.patch";
      sha256 = "082wcsqbn1kc0p2mqb1svz4pj5yxqj0ymq6aqxs57g9ryigwr6sz";
    })

    # https://github.com/posativ/isso/pull/615
    (fetchpatch {
      name = "python-3.8-support";
      url = "https://github.com/posativ/isso/pull/615.patch";
      sha256 = "0pwws93ginlf8scnaawqarhbf8dklx1rjsa4kna68bq3lp84bh70";
    })

    # https://github.com/posativ/isso/issues/659
    # https://github.com/posativ/isso/pull/660
    (fetchpatch {
      name = "flask-caching-fix";
      url = "https://github.com/posativ/isso/pull/660.patch";
      sha256 = "09jgd28ldf2zhmg83fjwrimfn97pvcd5fnssi4241gd7z8dafi58";
    })

    # https://github.com/posativ/isso/issues/599
    # https://github.com/posativ/isso/pull/600
    (fetchpatch {
      name = "cgi.parse-fix";
      url = "https://github.com/posativ/isso/pull/600.patch";
      sha256 = "1x0fhgc5326a25zsyn31l6n1wh877y5j72na6f8ff5x0k4p5qfr3";
    })
  ];

  propagatedBuildInputs = [
    bleach
    cffi
    configparser
    html5lib
    jinja2
    misaka
    werkzeug
    flask-caching
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = with lib; {
    description = "A commenting server similar to Disqus";
    homepage = "https://posativ.org/isso/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

