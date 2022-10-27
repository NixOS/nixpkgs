{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gam";
  version = "6.22";
  format = "other";

  src = fetchFromGitHub {
    owner = "GAM-team";
    repo = "gam";
    rev = "v${version}";
    sha256 = "sha256-G/S1Rrm+suiy1CTTFLcBGt/QhARL7puHgR65nCxodH0=";
  };

  sourceRoot = "source/src";

  patches = [
    # Also disables update check
    ./signal_files_as_env_vars.patch
  ];

  propagatedBuildInputs = with python3.pkgs; [
    distro
    filelock
    google-api-python-client
    google-auth
    google-auth-oauthlib
    passlib
    pathvalidate
    python-dateutil
    setuptools
  ];

  # Use XDG-ish dirs for configuration. These would otherwise be in the gam
  # package.
  #
  # Using --run as `makeWapper` evaluates variables for --set and --set-default
  # at build time and then single quotes the vars in the wrapper, thus they
  # wouldn't get expanded. But using --run allows setting default vars that are
  # evaluated on run and not during build time.
   makeWrapperArgs = [
    ''--run 'export GAMUSERCONFIGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMSITECONFIGDIR="''${XDG_CONFIG_HOME:-$HOME/.config}/gam"' ''
    ''--run 'export GAMCACHEDIR="''${XDG_CACHE_HOME:-$HOME/.cache}/gam"' ''
    ''--run 'export GAMDRIVEDIR="$PWD"' ''
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp gam.py $out/bin/gam
    mkdir -p $out/lib/${python3.libPrefix}/site-packages
    cp -r gam $out/lib/${python3.libPrefix}/site-packages
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest discover --pattern "*_test.py" --buffer
    runHook postCheck
  '';

  meta = with lib; {
    description = "Command line management for Google Workspace";
    homepage = "https://github.com/GAM-team/GAM/wiki";
    license = licenses.asl20;
    maintainers = with maintainers; [ thanegill ];
  };

}
