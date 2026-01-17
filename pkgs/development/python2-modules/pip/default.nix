{
  lib,
  buildPythonPackage,
  bootstrapped-pip,
  fetchFromGitHub,
  scripttest,
  virtualenv,
  pretend,
}:

buildPythonPackage rec {
  pname = "pip";
  version = "20.3.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "0hkhs9yc1cjdj1gn9wkycd3sy65c05q8k8rhqgsm5jbpksfssiwn";
    name = "${pname}-${version}-source";
  };

  nativeBuildInputs = [ bootstrapped-pip ];

  # pip detects that we already have bootstrapped_pip "installed", so we need
  # to force it a little.
  pipInstallFlags = [ "--ignore-installed" ];

  nativeCheckInputs = [
    scripttest
    virtualenv
    pretend
  ];

  # Pip wants pytest, but tests are not distributed
  doCheck = false;

  meta = {
    description = "PyPA recommended tool for installing Python packages";
    license = with lib.licenses; [ mit ];
    homepage = "https://pip.pypa.io/";
    priority = 10;
  };
}
