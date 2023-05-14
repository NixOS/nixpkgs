let
  pkgs = import ../../../../../. { };
in pkgs.mkShell {
  packages = [
    pkgs.python2
    pkgs.poetry
  ];
}
