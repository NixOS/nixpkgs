{ lib, pythonPackages, fetchurl }:

pythonPackages.buildPythonApplication rec {
  name = "mir.qualia-${version}";
  version = "1.0.0";
  doCheck = false; # 1.0.0-released pytests are broken

  buildInputs = with pythonPackages; [ pytest ];

  src = fetchurl {
    url = "mirror://pypi/m/mir.qualia/mir.qualia-${version}.tar.gz";
    sha256 = "1g0nwncwk4nq7b7zszqi1q4d2bdga1q50g9nkxigdaq647wqdf7x";
  };

  meta = {
    description = "Dynamically enable sections of config files";
    homepage = https://github.com/darkfeline/mir.qualia;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.srhb ] ;
  };
}
