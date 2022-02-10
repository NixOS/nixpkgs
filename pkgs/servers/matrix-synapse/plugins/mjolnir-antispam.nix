{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse, fetchpatch }:

buildPythonPackage rec {
  pname = "matrix-synapse-mjolnir-antispam";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "mjolnir";
    rev = "v${version}";
    sha256 = "05O7NgqlsVu4mdx1+0CZgBvwvBCWYg7nSFknJiXxuoc=";
  };

  patches = [
    #  Update legacy antispam plugin with newer types. Or it'll just ignore mjolnir 1.3.1 rules.
    (fetchpatch {
      url = "https://github.com/matrix-org/mjolnir/commit/eb8c5e08b4c2b78e6a796e38e826ac3b7e9dfbaf.patch";
      sha256 = "sha256-rfFU45PfxR2YmNRU74eBI9M2hqBVZcNH0Sw8W/cavD4=";
      stripLen = 1;
    })
    # Port to Synapse module API (needs Synapse >= 1.37.0)
    (fetchpatch {
      url = "https://github.com/matrix-org/mjolnir/commit/9c9bd0e02907412b5fa6b95844e9f53ac07b61fd.patch";
      sha256 = "sha256-HR2OvqFnlQwRV7ezfOjseatjo+3P8i9PsV7D+hLD1Yo=";
      stripLen = 1;
      excludes = [
        "README.md"
        "mx-tester.yml"
      ];
    })
    # Move glob_to_regex into the source
    (fetchpatch {
      url = "https://github.com/matrix-org/mjolnir/commit/6cb461fed424f07bf50a1fdc0693d40ed8bbee12.patch";
      sha256 = "sha256-tqcKXNs+fxwPIvN5sJjdNgcz5KUVHiXgulLHR2redYk=";
      stripLen = 1;
    })
  ];

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
