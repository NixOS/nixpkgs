{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "monsoon";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "RedTeamPentesting";
    repo = "monsoon";
    rev = "refs/tags/v${version}";
    hash = "sha256-5aV4/JEtaUEtE/csvch/JooeWNLpysqrI2hwVWMJhnI=";
  };

  vendorHash = "sha256-gdoOBW5MD94RiKINVtTDvBQRZaJ9tlgu0eh7MxuMezg=";

  # Tests fails on darwin
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Fast HTTP enumerator";
    mainProgram = "monsoon";
    longDescription = ''
      A fast HTTP enumerator that allows you to execute a large number of HTTP
      requests, filter the responses and display them in real-time.
    '';
    homepage = "https://github.com/RedTeamPentesting/monsoon";
    changelog = "https://github.com/RedTeamPentesting/monsoon/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
