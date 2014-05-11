{ stdenv, fetchurl, python27Packages, btrfsProgs }:

let
  python = python27Packages;
in
python.buildPythonPackage rec {
  name = "bedup-${version}";
  version = "v0.9.0-29-g5189e16";

  src = fetchurl {
     url = "https://github.com/g2p/bedup/archive/master.tar.gz";
     sha256 = "1c5053fxlinhl0nkn93c4g5m2wjxh4drs0za4g924zyk01gxl7zw";
  };

  python_deps = [ python.cffi python.pycparser python.contextlib2 python.sqlalchemy8 python.pyxdg python.alembic ];
  pythonPath = python_deps;
  buildInputs = [ btrfsProgs ];
  propagatedBuildInputs = python_deps;

  doCheck = false;

  meta = {
    description = "Btrfs deduplication";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
