{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fedifetcher";
  version = "7.1.6";
  format = "other";

  src = fetchFromGitHub {
    owner = "nanos";
    repo = "FediFetcher";
    rev = "refs/tags/v${version}";
    hash = "sha256-lnBiGBoG5ykKSP+F4NOqJKnvxaLU9oiV3KfbVnjgkgQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    python-dateutil
    requests
  ];

  installPhase = ''
    runHook preInstall

    install -vD find_posts.py $out/bin/fedifetcher

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for Mastodon that automatically fetches missing replies and posts from other fediverse instances";
    longDescription = ''
      FediFetcher is a tool for Mastodon that automatically fetches missing
      replies and posts from other fediverse instances, and adds them to your
      own Mastodon instance.
    '';
    homepage = "https://blog.thms.uk/fedifetcher";
    license = licenses.mit;
    maintainers = teams.c3d2.members;
    mainProgram = "fedifetcher";
  };
}
