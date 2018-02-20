{ lib, buildPythonApplication, fetchFromGitHub, python, protobuf, sqlite, roundup }:

buildPythonApplication rec {
  pname = "ddar";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "basak";
    repo = pname;
    rev = "v${version}";
    sha256 = "158jdy5261k9yw540g48hddy5zyqrr81ir9fjlcy4jnrwfkg7ynm";
  };

  preBuild = ''
    make -f Makefile.prep synctus/ddar_pb2.py
  '';

  propagatedBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Unix de-duplicating archiver";
    license = licenses.gpl3;
    homepage = src.meta.homepage;
  };
}
