{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
}:

let
  pname = "sdbus";
  version = "0.14.0";
in
buildPythonPackage {
  inherit pname version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pkgs.systemd ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QdYbdswFqepB0Q1woR6fmobtlfQPcTYwxeGDQODkx28=";
  };
}
