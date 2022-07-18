{ lib
, buildGoModule
, fetchFromGitHub
, testers
, adrgen
}:

buildGoModule rec {
  pname = "adrgen";
  version = "0.4.0-beta";

  src = fetchFromGitHub {
    owner = "asiermarques";
    repo = "adrgen";
    rev = "v${version}";
    sha256 = "sha256-2ZE/orsfwL59Io09c4yfXt2enVmpSM/QHlUMgyd9RYQ=";
  };

  vendorSha256 = "sha256-aDtUD+KKKSE0TpSi4+6HXSBMqF/TROZZhT0ox3a8Idk=";

  passthru.tests.version = testers.testVersion {
    package = adrgen;
    command = "adrgen version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/asiermarques/adrgen";
    description = "A command-line tool for generating and managing Architecture Decision Records";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.ivar ];
  };
}
