{ lib, pythonPackages, fetchurl }:

pythonPackages.buildPythonApplication rec {
  pname = "mir.qualia";
  version = "2.0.0";
  doCheck = false; # 2.0.0-released pytests are broken

  buildInputs = with pythonPackages; [ pytest ];

  src = fetchurl {
    url = "mirror://pypi/m/mir.qualia/mir.qualia-${version}.tar.gz";
    hash = "sha256-qSJGnXMKAcHYQwReFX2q84ktIbktjqsBhwlSVpY0ePk=";
  };

  meta = {
    description = "Dynamically enable sections of config files";
    mainProgram = "qualia";
    homepage = "https://github.com/darkfeline/mir.qualia";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.srhb ] ;
  };
}
