{ lib
, mkYarnPackage
, fetchFromGitHub
}:

mkYarnPackage rec {
  pname = "observatory-cli";
  version = "unstable-2021-09-20";
  src = fetchFromGitHub {
    owner = "mozilla";
    repo = pname;
    rev = "0c2cf602f4cd15b26359d7981e6f084924fa9971";
    hash = "sha256-+v3d5HYZXCE4tPYsIDSEyrof6b6lJEBCRntGjeL4DHk=";
  };
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  meta = with lib; {
    description = "Command line client for Mozilla HTTP observatory service";
    homepage = "https://github.com/mozilla/observatory-cli";
    license = licenses.mpl20;
    maintainers = with maintainers; [ erdnaxe ];
  };
}
