{ windowsSupport ? true, stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  version = "1.9.3";
  name = "ansible-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://releases.ansible.com/ansible/ansible-${version}.tar.gz";
    sha256 = "1vgfsjqb5gbs30ymqgq3q2kxzn3fvh8680n14yj5c040zm1gd515";
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
