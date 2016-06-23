{ lib, pythonPackages, fetchurl }:

let version = "0.7.6";

in pythonPackages.buildPythonApplication rec {
  name = "cloud-init-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://launchpad.net/cloud-init/trunk/${version}/+download/cloud-init-${version}.tar.gz";
    sha256 = "1mry5zdkfaq952kn1i06wiggc66cqgfp6qgnlpk0mr7nnwpd53wy";
  };

  patchPhase = ''
    patchShebangs ./tools

    substituteInPlace setup.py \
      --replace /usr $out \
      --replace /etc $out/etc \
      --replace /lib/systemd $out/lib/systemd \
      --replace 'self.init_system = ""' 'self.init_system = "systemd"'
    '';

  propagatedBuildInputs = with pythonPackages; [ cheetah jinja2 prettytable
    oauth pyserial configobj pyyaml argparse requests jsonpatch ];

  meta = {
    homepage = http://cloudinit.readthedocs.org;
    description = "Provides configuration and customization of cloud instance";
    maintainers = [ lib.maintainers.madjar ];
    platforms = lib.platforms.all;
  };
}
