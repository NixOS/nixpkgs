{ lib, pythonPackages, fetchurl, cloud-utils }:

let version = "0.7.9";

in pythonPackages.buildPythonApplication rec {
  name = "cloud-init-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://launchpad.net/cloud-init/trunk/${version}/+download/cloud-init-${version}.tar.gz";
    sha256 = "0wnl76pdcj754pl99wxx76hkir1s61x0bg0lh27sdgdxy45vivbn";
  };

  patches = [ ./add-nixos-support.patch ];
  prePatch = ''
    patchShebangs ./tools

    substituteInPlace setup.py \
      --replace /usr $out \
      --replace /etc $out/etc \
      --replace /lib/systemd $out/lib/systemd \
      --replace 'self.init_system = ""' 'self.init_system = "systemd"'

    substituteInPlace cloudinit/config/cc_growpart.py \
      --replace 'util.subp(["growpart"' 'util.subp(["${cloud-utils}/bin/growpart"'

    # Argparse is part of python stdlib
    sed -i s/argparse// requirements.txt
    '';

  propagatedBuildInputs = with pythonPackages; [ cheetah jinja2 prettytable
    oauthlib pyserial configobj pyyaml requests jsonpatch ];

  checkInputs = with pythonPackages; [ contextlib2 httpretty mock unittest2 ];

  doCheck = false;

  meta = {
    homepage = https://cloudinit.readthedocs.org;
    description = "Provides configuration and customization of cloud instance";
    maintainers = [ lib.maintainers.madjar lib.maintainers.phile314 ];
    platforms = lib.platforms.all;
  };
}
