{ stdenv, fetchFromGitHub, fetchpatch, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.6.2";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1kk9k2gcxc18b1nn563xv74rx2cf8jh4j3gvbsvbk1a4wps3za22";
  };

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with pythonPackages; [ acme setuptools_scm ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zenhack/simp_le;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
