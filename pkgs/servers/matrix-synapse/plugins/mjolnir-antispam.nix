{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse }:

buildPythonPackage rec {
  pname = "matrix-synapse-mjolnir-antispam";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "v${version}";
    sha256 = "HDfLndiFm9ayCmixuv4MYBbQ76mzCtTS+4UuBRdpP0E=";
  };

  sourceRoot = "./source/synapse_antispam";

  propagatedBuildInputs = [ matrix-synapse ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "mjolnir" ];

  meta = with lib; {
    description = "AntiSpam / Banlist plugin to be used with mjolnir";
    longDescription = ''
      Primarily meant to block invites from undesired homeservers/users,
      Mjolnir's Synapse module is a way to interpret ban lists and apply
      them to your entire homeserver.
    '';
    homepage = "https://github.com/matrix-org/mjolnir#synapse-module";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
  };
}
