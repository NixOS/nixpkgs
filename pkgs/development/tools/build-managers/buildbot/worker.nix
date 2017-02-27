{ stdenv, fetchurl, gnused, coreutils, pythonPackages }:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot-worker";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "0rdrr8x7sn2nxl51p6h9ad42s3c28lb6sys84zrg0d7fm4zhv7hj";
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
    license = licenses.gpl2;
  };
})
