{ lib
, python3
, fetchFromGitHub
, installShellFiles
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ripe-atlas-tools";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = "ripe-atlas-tools";
    rev = "v${version}";
    sha256 = "sha256-5AMqBXxJZOtI0/2NrEjrUfNXWKc7sn6kZX26766LBUM=";
  };

  postPatch = ''
    # This mapping triggers network access on docs generation: https://github.com/RIPE-NCC/ripe-atlas-tools/issues/235
    sed -i '/^intersphinx_mapping/d' docs/conf.py
    # TODO: Ensure user-agent is picked up during build, remove me when https://github.com/RIPE-NCC/ripe-atlas-tools/pull/236
    echo "include ripe/atlas/tools/user-agent" >> MANIFEST.in
  '';

  nativeBuildInputs = with python3.pkgs; [
    sphinx-rtd-theme
    sphinxHook
    installShellFiles
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ripe-atlas-cousteau
    ripe-atlas-sagan
    ujson
    ipy
    python-dateutil
    requests
    tzlocal
    pyyaml
    pyopenssl
  ];

  preBuild = ''
    echo "RIPE Atlas Tools [NixOS ${lib.trivial.version}] ${version}" > ripe/atlas/tools/user-agent
  '';

  postInstall = ''
    installShellCompletion --cmd ripe-atlas --bash ./ripe-atlas-bash-completion.sh
  '';

  pythonImportsCheck = [
    "ripe.atlas.tools"
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # Network tests: https://github.com/RIPE-NCC/ripe-atlas-tools/issues/234
    "test_arg_from_file"
    "test_arg_from_stdin"
    # We injected our user-agent so the tests will fail
    "test_user_agent_mac"
    "test_user_agent_windows"
    "test_user_agent_xdg_absent"
    "test_user_agent_xdg_present"
  ];

  disabledTestPaths = [
    # Relies on `ripe-atlas` being available in the PATH, installed with autocompletions
    "tests/test_bash_completion.py"
    # AS lookups are not mocked up: https://github.com/RIPE-NCC/ripe-atlas-tools/blob/master/tests/renderers/test_traceroute_aspath.py#L26
    "tests/renderers/test_traceroute_aspath.py"
    # We already build Sphinx so we do not need to test it
    "tests/test_docs.py"
  ];

  HOME = "$TMPDIR"; # for cache generation.

  # Necessary because it confuse the tests when it does "from ripe.atlas.sagan import X"
  # version.py is used by Sphinx tests.
  preCheck = ''
    rm -rf ripe
    mkdir -p ripe/atlas/tools
    echo "__version__ = \"${version}\"" > ripe/atlas/tools/version.py
  '';

  meta = with lib; {
    description = "RIPE ATLAS project tools";
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-tools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
