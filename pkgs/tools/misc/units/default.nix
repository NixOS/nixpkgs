{
  stdenv,
  lib,
  fetchurl,
  readline,
  enableCurrenciesUpdater ? true,
  pythonPackages ? null
}:

assert enableCurrenciesUpdater -> pythonPackages != null;

stdenv.mkDerivation rec {
  pname = "units";
  version = "2.19";

  src = fetchurl {
    url = "mirror://gnu/units/${pname}-${version}.tar.gz";
    sha256 = "0mk562g7dnidjgfgvkxxpvlba66fh1ykmfd9ylzvcln1vxmi6qj2";
  };

  pythonEnv = pythonPackages.python.withPackages(ps: [
    ps.requests
  ]);

  buildInputs = [ readline ]
    ++ lib.optionals enableCurrenciesUpdater [
      pythonEnv
    ]
  ;
  prePatch = ''
    substituteInPlace units_cur \
      --replace "#!/usr/bin/env python" ${pythonEnv}/bin/python
  '';
  postInstall = ''
    cp units_cur ${placeholder "out"}/bin/
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Unit conversion tool";
    homepage = https://www.gnu.org/software/units/;
    license = [ licenses.gpl3Plus ];
    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
}
