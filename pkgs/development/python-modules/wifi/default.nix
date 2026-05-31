{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbkdf2,
  pytestCheckHook,
  wirelesstools,
}:

buildPythonPackage rec {
  pname = "wifi";
  version = "0.3.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rockymeza";
    repo = "wifi";
    rev = "v${version}";
    hash = "sha256-scg/DvApvyQZtzDgkHFJzf9gCRfJgBvZ64CG/c2Cx8E=";
  };

  postPatch = ''
    substituteInPlace wifi/scan.py \
      --replace "/sbin/iwlist" "${wirelesstools}/bin/iwlist"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ pbkdf2 ];

  pythonImportsCheck = [ "wifi" ];

  meta = {
    description = "Provides a command line wrapper for iwlist and /etc/network/interfaces";
    mainProgram = "wifi";
    homepage = "https://github.com/rockymeza/wifi";
    maintainers = with lib.maintainers; [ rhoriguchi ];
    license = lib.licenses.bsd2;
  };
}
