{
  lib,
  pythonPackages,
  fetchurl,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mir.qualia";
  version = "2.0.0";
  doCheck = false; # 2.0.0-released pytests are broken

  buildInputs = with pythonPackages; [ pytest ];

  src = fetchurl {
    url = "mirror://pypi/m/mir.qualia/mir.qualia-${version}.tar.gz";
    sha256 = "1ybq6jb5clh9hw0sp3idp4hjv2gkm9yiaph48gcc208affflc8m9";
  };

  meta = {
    description = "Dynamically enable sections of config files";
    mainProgram = "qualia";
    homepage = "https://github.com/darkfeline/mir.qualia";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.srhb ];
  };
}
