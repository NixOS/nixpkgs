{ python2Packages, lib }:

with python2Packages;

buildPythonApplication rec {

  name = "${pname}-${version}";
  pname = "cloudmonkey";
  version = "5.3.3";

  propagatedBuildInputs = [ argcomplete pygments ];

  doCheck = false; # upstream has no tests defined

  src = fetchPypi {
    inherit pname version;
    sha256 = "064yk3lwl272nyn20xxrh0qxzh3r1rl9015qqf2i4snqdzwd5cf7";
  };

  meta = with lib; {
    description = "CLI for Apache CloudStack.";
    homepage = https://cwiki.apache.org/confluence/display/CLOUDSTACK/CloudStack+cloudmonkey+CLI;
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };

}
