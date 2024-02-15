{
  stdenv,
  lib,
  fetchurl,
  readline,
  enableCurrenciesUpdater ? true,
  pythonPackages ? null
}:

assert enableCurrenciesUpdater -> pythonPackages != null;

let pythonEnv = pythonPackages.python.withPackages(ps: [
      ps.requests
    ]);
in stdenv.mkDerivation rec {
  pname = "units";
  version = "2.22";

  src = fetchurl {
    url = "mirror://gnu/units/${pname}-${version}.tar.gz";
    sha256 = "sha256-XRPhIHch/ncm2Qa6HZLcDt2qn8JnWe0i47jRp5MSWEg=";
  };

  buildInputs = [ readline ]
    ++ lib.optionals enableCurrenciesUpdater [
      pythonEnv
    ]
  ;
  prePatch = lib.optionalString enableCurrenciesUpdater ''
    substituteInPlace units_cur \
      --replace "#!/usr/bin/env python" ${pythonEnv}/bin/python
  '';
  postInstall = ''
    cp units_cur ${placeholder "out"}/bin/
  '';

  doCheck = true;

  meta = with lib; {
    description = "Unit conversion tool";
    homepage = "https://www.gnu.org/software/units/";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
}
