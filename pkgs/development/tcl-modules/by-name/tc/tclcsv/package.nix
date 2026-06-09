{
  lib,
  mkTclDerivation,
  fetchzip,
}:

mkTclDerivation rec {
  pname = "tclcsv";
  version = "2.4.3";

  src = fetchzip {
    url = "mirror://sourceforge/tclcsv/tclcsv${version}-src.tar.gz";
    hash = "sha256-bNRMgIyUSy4TnOGq9FPCXr79NIkcRfy2SqO5/i+DC/w=";
  };

  meta = {
    changelog = "https://tclcsv.magicsplat.com/#_version_history";
    description = "Tcl extension for reading and writing CSV files";
    downloadPage = "https://sourceforge.net/projects/tclcsv/files/";
    homepage = "https://tclcsv.magicsplat.com/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
