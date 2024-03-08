{ lib, stdenv, buildPythonPackage, fetchFromGitHub, matrix-synapse-unwrapped }:

buildPythonPackage rec {
  pname = "matrix-synapse-mjolnir-antispam";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-xejFKz2MmdjMFU0X0SdI+qXTBRAwIvkcfZPQqXB9LV0=";
  };

  sourceRoot = "${src.name}/synapse_antispam";

  buildInputs = [ matrix-synapse-unwrapped ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "mjolnir" ];

  meta = with lib; {
    description = "AntiSpam / Banlist plugin to be used with mjolnir";
    longDescription = ''
      Primarily meant to block invites from undesired homeservers/users,
      Mjolnir's Synapse module is a way to interpret ban lists and apply
      them to your entire homeserver.
    '';
    homepage = "https://github.com/matrix-org/mjolnir/blob/main/docs/synapse_module.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ jojosch ];
    broken = stdenv.isDarwin;
  };
}
