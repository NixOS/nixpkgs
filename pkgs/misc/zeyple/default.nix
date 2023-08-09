{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "zeyple";
  version = "unstable-2021-04-10";

  format = "other";

  src = fetchFromGitHub {
    owner = "infertux";
    repo = "zeyple";
    rev = "cc125b7b44432542b227887fd7e2701f77fd8ca2";
    sha256 = "0r2d1drg2zvwmn3zg0qb32i9mh03r5di9q1yszx23r32rsax9mxh";
  };

  propagatedBuildInputs = [ python3Packages.pygpgme ];
  installPhase = ''
    install -Dm755 $src/zeyple/zeyple.py $out/bin/zeyple
  '';

  meta = with lib; {
    description = "Utility program to automatically encrypt outgoing emails with GPG";
    homepage = "https://infertux.com/labs/zeyple/";
    maintainers = with maintainers; [ ettom ];
    license = licenses.agpl3Plus;
  };
}
