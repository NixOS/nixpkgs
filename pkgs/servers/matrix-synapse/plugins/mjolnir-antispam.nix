{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse }:

buildPythonPackage rec {
  pname = "matrix-synapse-mjolnir-antispam";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-pTQF3iUXJv953I/savQu/aUK0R1ujE6IrN68FkKO9sU=";
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
