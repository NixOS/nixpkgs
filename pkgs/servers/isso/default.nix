{ stdenv, python2, fetchurl, fetchFromGitHub }:

let python = python2.override {
  packageOverrides = self: super: {
    misaka = super.misaka.overridePythonAttrs (old: rec {
      version = "1.0.2";
      src = old.src.override {
        inherit version;
        sha256 = "05rmjxlfhghj90m1kc55lx3z8igabw5y8wmly66p3hphdy4f95v1";
      };
      propagatedBuildInputs = [ ];
    });
    html5lib = super.html5lib.overridePythonAttrs (old: rec {
      version = "0.9999999";
      src = old.src.override {
        inherit version;
        sha256 = "2612a191a8d5842bfa057e41ba50bbb9dcb722419d2408c78cff4758d0754868";
      };
      checkInputs = with self; [ nose flake8 ];
      propagatedBuildInputs = with self; [ six ];
      checkPhase = ''
        nosetests
      '';
    });
  };
};

in with python.pkgs; buildPythonApplication rec {
  pname = "isso";
  version = "0.10.6";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = version;
    sha256 = "19x9xbwd15fikhchyl4i1wrqx589hdmh279xhnxdszrq898igywb";
  };

  propagatedBuildInputs = [ misaka werkzeug ipaddr configparser html5lib ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = with stdenv.lib; {
    description = "A commenting server similar to Disqus";
    homepage = https://posativ.org/isso/;
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
