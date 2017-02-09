{ stdenv, fetchurl, gnused, coreutils, pythonPackages }:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot-worker";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "176kp04g4c7gj15f73wppraqrirbfclyx214gcz966019niikcsp";
  };

  buildInputs = with pythonPackages; [ setuptoolsTrial mock ];
  propagatedBuildInputs = with pythonPackages; [ twisted future ];

  postPatch = ''
    ${gnused}/bin/sed -i 's|/usr/bin/tail|${coreutils}/bin/tail|' buildbot_worker/scripts/logwatcher.py
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Worker Daemon";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
})
