{ stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  version = "1.6.10";
  name = "ansible-${version}";
  namePrefix = "";
  
  src = fetchurl {
    url = "https://github.com/ansible/ansible/archive/v${version}.tar.gz";
    sha256 = "0j133353skzb6ydrqqgfkzbkkj1zaibl1x8sgl0arnfma8qky1g1";
  };

  prePatch = ''
    sed -i "s,\/usr\/share\/ansible\/,$out/share/ansible," lib/ansible/constants.py 
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  propagatedBuildInputs = with pythonPackages; [
    paramiko jinja2 pyyaml httplib2 boto
  ];

  postFixup = ''
      wrapPythonProgramsIn $out/bin "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.ansible.com";
    description = "A simple automation tool";
    license = licenses.gpl3;
    maintainers = [ maintainers.joamaki ];
    platforms = platforms.linux; # Only tested on Linux
  };
}
