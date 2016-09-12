{ stdenv
, fetchurl
, pythonPackages
}:

pythonPackages.buildPythonApplication (rec {
  name = "buildbot-worker-${version}";
  version = "0.9.0rc2";

  src = fetchurl {
    url = "https://pypi.python.org/packages/6a/be/ae80e5e87bc92ac813cd944c08d3b6168090145fc168e7a553e88c07067a/${name}.tar.gz";
    sha256 = "19l28s2fyzln6nv2ypbdg11xiz7lrjy0n64fzhngfalv61x2bp8j";
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
