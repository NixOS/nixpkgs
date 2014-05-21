{ stdenv, pythonPackages, fetchurl, python }:

pythonPackages.buildPythonPackage rec {
  name = "ansible-1.6.1";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/ansible/ansible/archive/v1.6.1.tar.gz";
    sha256 = "1iz1q2h0zll4qsxk0pndc59knasw663kv53sm21q57qz7lf30q9z";
  };

  prePatch = ''
    sed -i "s,\/usr\/share\/ansible\/,$out/share/ansible," lib/ansible/constants.py 
  '';

  doCheck = false;

  pythonPath = with pythonPackages; [
    paramiko jinja2 pyyaml httplib2
  ];

  meta = {
    homepage = "http://www.ansible.com";
    description = "Ansible simple automation tool";
    license = "GPLv3";
  };
}
