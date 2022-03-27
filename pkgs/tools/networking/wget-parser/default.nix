{ lib
, mkYarnPackage
, fetchFromGitHub
}:

mkYarnPackage rec {
  pname = "wget-parser";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "tmpfs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GSCVaW57qnXTppttX5yItLjlIS9LKj5PwXSW1j0v+7Y==";
  };
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  postInstall = ''
    ln -s $out/libexec/${pname}/deps/${pname}/bin/* $out/bin/
  '';

  meta = with lib; {
    description = "Parses the wget spider output";
    homepage = "https://github.com/tmpfs/wget-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ erdnaxe ];
  };
}
