{ stdenv, fetchurl }:    

{
  shinken = buildPythonPackage rec {
    version = "2.4.3";
    name = "Shinken-${version}";
    disabled = isPy3k; # Python 3 is not supported

    src = pkgs.fetchurl {
      url = "https://pypi.python.org/packages/source/S/Shinken/${name}.tar.gz";
      sha256 = "1hxbnxlk2bacb7p6lim9kqy50581m0d3p3y6b9hw0x800lfk0y6q";
    };

    dontStrip = true; # no binaries to strip, so the build process generates lots of warnings

    # missing: logging tagging

    propagatedBuildInputs = with self; [
      arrow bottle cffi cherrypy django paramiko pycurl pymongo pyopenssl
    ];

    checkPhase = ''
      cd $out/test
      ./quick_test.sh
    '';

    meta = {
      homepage = http://www.shinken-monitoring.org/;
      description = "A monitoring framework compatible with Nagios configuration and plugins";
      license = licenses.agpl3;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };
}
