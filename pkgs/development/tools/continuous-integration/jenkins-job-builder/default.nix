{ stdenv, fetchurl, pythonPackages, buildPythonPackage, git }:

let
  upstreamName = "jenkins-job-builder";
  version = "1.2.0";

in

buildPythonPackage rec {
  name = "${upstreamName}-${version}";
  namePrefix = "";  # Don't prepend "pythonX.Y-" to the name

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/j/${upstreamName}/${name}.tar.gz";
    sha256 = "09nxdhb0ilxpmk5gbvik6kj9b6j718j5an903dpcvi3r6vzk9b3p";
  };

  pythonPath = with pythonPackages; [ pip six pyyaml pbr python-jenkins ];
  doCheck = false;  # Requires outdated Sphinx

  meta = {
    description = "System for configuring Jenkins jobs using simple YAML files";
    homepage = http://ci.openstack.org/jjb.html;
    license = stdenv.lib.licenses.asl20;
  };
}
