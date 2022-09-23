{ runCommand, phoronix-test-suite }:

let
  inherit (phoronix-test-suite) pname version;
in

runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    # automatic initial setup to prevent interactive questions
    ${phoronix-test-suite}/bin/phoronix-test-suite enterprise-setup >/dev/null
    # get version of installed program and compare with package version
    if [[ `${phoronix-test-suite}/bin/phoronix-test-suite version` != *"${version}"*  ]]; then
      echo "Error: program version does not match package version"
      exit 1
    fi
    # run dummy command
    ${phoronix-test-suite}/bin/phoronix-test-suite dummy_module.dummy-command >/dev/null
    # needed for Nix to register the command as successful
    touch $out
  ''
