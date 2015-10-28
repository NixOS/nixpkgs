{ windowsSupport ? true, stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  version = "1.9.4";
  name = "ansible-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://releases.ansible.com/ansible/${name}.tar.gz";
    sha256 = "1qvgzb66nlyc2ncmgmqhzdk0x0p2px09967p1yypf5czwjn2yb4p";
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
