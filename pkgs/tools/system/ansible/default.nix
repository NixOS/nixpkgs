{ windowsSupport ? true, stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  version = "1.9.1";
  name = "ansible-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://releases.ansible.com/ansible/ansible-${version}.tar.gz";
    sha256 = "a6f975d565723765a4d490ff40cede96833a745f38908def4950a0075f1973f5";
  };

  prePatch = ''
    sed -i "s,\/usr\/share\/ansible\/,$out/share/ansible," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  propagatedBuildInputs = with pythonPackages; [
    paramiko jinja2 pyyaml httplib2 boto six
  ] ++ stdenv.lib.optional windowsSupport pywinrm;

  postFixup = ''
      wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.ansible.com";
    description = "A simple automation tool";
    license = licenses.gpl3;
    maintainers = [ maintainers.joamaki ];
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
  };
}
