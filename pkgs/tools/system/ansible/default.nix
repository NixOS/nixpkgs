{ stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  version = "1.6.1";		    
  name = "ansible-${version}";
  namePrefix = "";
  
  src = fetchurl {
    url = "https://github.com/ansible/ansible/archive/v${version}.tar.gz";
    sha256 = "1iz1q2h0zll4qsxk0pndc59knasw663kv53sm21q57qz7lf30q9z";
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
