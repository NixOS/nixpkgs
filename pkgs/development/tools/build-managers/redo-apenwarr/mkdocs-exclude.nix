{ pythonPackages, isPy3k, pkgs }:

pythonPackages.buildPythonPackage rec {
  name = "mkdocs-exclude";
  disabled = isPy3k;

  src = pkgs.fetchFromGitHub {
    owner = "apenwarr";
    repo = "mkdocs-exclude";
    rev = "fdd67d2685ff706de126e99daeaaaf3f6f7cf3ae";
    sha256 = "1phhl79xf4xq8w2sb2w5zm4bahcr33gsbxkz7dl1dws4qhcbxrfd";
  };

  buildInputs = with pkgs; [
    mkdocs
  ];

  # error: invalid command 'test'
  doCheck = false;
}
