{ buildGoModule
, fetchFromGitHub
, python3Packages
}:
let
  mkBasePackage =
    { pname
    , src
    , version
    , vendorHash
    , cmd
    , extraLdflags
    , env
    , ...
    }@args: buildGoModule (rec {
      inherit pname src vendorHash version env;

      sourceRoot = "${src.name}/provider";

      subPackages = [ "cmd/${cmd}" ];

      doCheck = false;

      ldflags = [
        "-s"
        "-w"
      ] ++ extraLdflags;
    } // args);

  mkPythonPackage =
    { meta
    , pname
    , src
    , version
    , ...
    }: python3Packages.callPackage
      ({ buildPythonPackage, pythonOlder, parver, pip, pulumi, semver, setuptools }:
      buildPythonPackage rec {
        inherit pname meta src version;
        format = "pyproject";

        disabled = pythonOlder "3.7";

        sourceRoot = "${src.name}/sdk/python";

        propagatedBuildInputs = [
          parver
          pulumi
          semver
          setuptools
        ];

        postPatch = ''
          if [[ -e "pyproject.toml" ]]; then
            sed -i \
              -e 's/^  version = .*/  version = "${version}"/g' \
              pyproject.toml
          else
            sed -i \
               -e 's/^VERSION = .*/VERSION = "${version}"/g' \
               -e 's/^PLUGIN_VERSION = .*/PLUGIN_VERSION = "${version}"/g' \
               setup.py
          fi
        '';

        # Auto-generated; upstream does not have any tests.
        # Verify that the version substitution works
        checkPhase = ''
          runHook preCheck

          ${pip}/bin/pip show "${pname}" | grep "Version: ${version}" > /dev/null \
            || (echo "ERROR: Version substitution seems to be broken"; exit 1)

          runHook postCheck
        '';

        pythonImportsCheck = [
          (builtins.replaceStrings [ "-" ] [ "_" ] pname)
        ];
      })
      { };
in
{ owner
, repo
, rev
, version
, hash
, vendorHash
, cmdGen
, cmdRes
, extraLdflags
, env ? { }
, meta
, fetchSubmodules ? false
, ...
}@args:
let
  src = fetchFromGitHub {
    name = "source-${repo}-${rev}";
    inherit owner repo rev hash fetchSubmodules;
  };

  pulumi-gen = mkBasePackage rec {
    inherit src version vendorHash extraLdflags env;

    cmd = cmdGen;
    pname = cmdGen;
  };
in
mkBasePackage ({
  inherit meta src version vendorHash extraLdflags env;

  pname = repo;

  nativeBuildInputs = [
    pulumi-gen
  ];

  cmd = cmdRes;

  postConfigure = ''
    pushd ..

    chmod +w sdk/
    ${cmdGen} schema

    popd

    VERSION=v${version} go generate cmd/${cmdRes}/main.go
  '';

  passthru.sdks.python = mkPythonPackage {
    inherit meta src version;

    pname = repo;
  };
} // args)
