{ lib
, buildPythonPackage
, fetchFromGitHub
, gnumake
, python
}:

# The branches SCRAMV2 and SCRAMV3 in github:cms-sw/SCRAM belongs to different trees,
# and the implementation is totally different -- SCRAMV2 is based on Perl scripts and Makefiles,
# while SCRAMV3 is a Python package.
# They just share the same CLI interface.

# SCRAM relies on CernVM File System (CVMFS), a repository/database located at CMS_PATH.
# The content of CVMFS contains a huge amount of hard-coded paths and is not relocatable.
# Both packages, scram_2 and scram_3, are expected to be uesd inside a system where CVMFS is distributed,
# or at least where /cvmfs is mounted.

(buildPythonPackage {
  pname = "scram";
  # There's currently no version tag along the branch SCRAMV3.
  # Since it's Python version is specified as 3.0.0, I hereby
  # made up a previous version referencing the version format used on SCRAMV2.
  version = "3.0.0-pre00-unstable-2023-10-27";

  src = fetchFromGitHub {
    owner = "cms-sw";
    repo = "SCRAM";
    # Reference "SCRAMV3"
    rev = "49a36349e8482b5953e79b49352b80eb234c50e6";
    hash = "sha256-rYFh11kLhVOzgLKYJXPHBf6bgsQqL7DB1ISsFWAJbPI=";
  };

  postPatch = ''
    # Ignore the specified version for the test_require packages
    sed -E -i "s/^([ ]*')(pytest|mock|flake8)==[a-z0-9\\.\\-]+(',)\$/\\1\\2\\3/" setup.py

    # Use usual string literals instead of byte strings
    substituteInPlace setup.py \
      --replace "filename.endswith(b'.py')" "filename.endswith('.py')"

    # Fix argument changes
    substituteInPlace "SCRAM/BuildSystem/MakeInterface.py" \
      --replace "def exec(self, args, opts):" "def exec(self, args=[], opts=__import__('argparse').Namespace(verbose=False)):" \
      --replace "execl(script, *gmake_arg)" "print('LOCALTOP:', environ['LOCALTOP'], 'SCRAM_CONFIGDIR:', environ['SCRAM_CONFIGDIR'], 'script:', script, 'gmake_arg:', gmake_arg); execl(script, *gmake_arg)"
  '';

  LOCALTOP = placeholder "out";

  preConfigure = ''
    SCRAM_CONFIGDIR=config
    mkdir -p "$LOCALTOP/$SCRAM_CONFIGDIR/SCRAM"
    cat <<EOF > "$LOCALTOP/$SCRAM_CONFIGDIR/SCRAM/run_gmake.sh"
    #!/bin/sh
    exec -a gmake ${gnumake}/bin/make "\$@"
    EOF
    chmod +x "$LOCALTOP/$SCRAM_CONFIGDIR/SCRAM/run_gmake.sh"
    patchShebangs --host "$LOCALTOP/$SCRAM_CONFIGDIR/SCRAM/run_gmake.sh"
  '';

  # Seems like the upstream hasn't made the checks pass
  doCheck = false;

  nativeCheckInputs = (with python.pkgs; [
    flake8
    mock
    pytest
  ]);

  postInstall = ''
    if [[ -e "$out/bin/SCRAM" ]]; then
      rm "$out/bin/SCRAM"
    fi
    mv cli/scram.py "$out/bin"
  '';

  postFixup = ''
    ln -s "$out/bin/scram.py" "$out/bin/scram"
  '';

  meta = with lib; {
    description = "Software Configuration And Management - CMS internal build tool";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "scram";
  };
  # Workaround buildPythonPackage's lack of finalAttrs support
}).overrideAttrs (finalAttrs: previousAttrs: {
  SCRAM_VERSION = "V3_0_0";

  # Name of the environment variable to get CMS_PATH from.
  # If null, get directly from CMS_PATH specified by overrideAttrs.
  getCmsPathFromEnv = "CMS_PATH";

  postPatch = previousAttrs.postPatch or "" + ''
    substituteInPlace "SCRAM/__init__.py" \
      --replace "@SCRAM_VERSION@" "$SCRAM_VERSION" \
      --replace "'@CMS_PATH@'" ${lib.escapeShellArg (if finalAttrs.getCmsPathFromEnv != null then "environ['${finalAttrs.getCmsPathFromEnv}']" else "r'${finalAttrs.CMS_PATH}'")}
  '';

  passthru = previousAttrs.passthru or { } // {
    tests = previousAttrs.passthru.tests or { } // {
      with-imports-check = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
        pythonImportsCheck = [
          "SCRAM"
        ];
      } // lib.optionalAttrs (previousAttrs.getCmsPathFromEnv != null) {
        # For testing purpose
        env.${previousAttrs.getCmsPathFromEnv} = "";
      });
    };
  };
})
