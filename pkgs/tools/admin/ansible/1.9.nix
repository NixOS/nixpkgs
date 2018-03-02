{ stdenv
, fetchurl
, fetchFromGitHub
, pythonPackages
, windowsSupport ? false
}:

with pythonPackages;

let
  jinja = jinja2.overridePythonAttrs (old: rec {
    version = "2.8.1";
    name = "${old.pname}-${version}";
    src = fetchFromGitHub {
      owner = "pallets";
      repo = "jinja";
      rev = version;
      sha256 = "0m6g6fx6flxb6hrkw757mbx1gxyrmj50w27m2afdsvmvz0zpdi2a";
    };
  });
in buildPythonPackage rec {
  version = "1.9.4";
  name = "ansible-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://releases.ansible.com/ansible/${name}.tar.gz";
    sha256 = "1qvgzb66nlyc2ncmgmqhzdk0x0p2px09967p1yypf5czwjn2yb4p";
  };

  prePatch = ''
    sed -i "s,/usr/,$out," lib/ansible/constants.py
  '';

  doCheck = false;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  propagatedBuildInputs = with pythonPackages; [
    pycrypto jinja paramiko pyyaml httplib2 boto six netaddr dnspython
  ] ++ stdenv.lib.optional windowsSupport pywinrm;

  meta = with stdenv.lib; {
    homepage = "http://www.ansible.com";
    description = "A simple automation tool";
    license = licenses.gpl3;
    maintainers = [ maintainers.xnaveira ];
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
  };
}
