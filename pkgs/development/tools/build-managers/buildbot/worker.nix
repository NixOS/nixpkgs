{ stdenv
, fetchurl
, pythonPackages
}:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot-worker";
  version = "0.9.0rc3";

  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "0wqn2176rk7hc27r4hfy5qnxp0nr9iis5nyzg5x07xljnsspnhy1";
  };

  buildInputs = with pythonPackages; [ setuptoolsTrial mock ];
  propagatedBuildInputs = with pythonPackages; [ twisted future ];

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
  };
})
