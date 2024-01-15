{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "fedifetcher";
  version = "7.0.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "nanos";
    repo = "FediFetcher";
    rev = "v${version}";
    hash = "sha256-/Au6a93na3meb2j0eR8UCCg+TVW/UqWz3/TkASB94Eg=";
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
    description = "A tool for Mastodon that automatically fetches missing replies and posts from other fediverse instances";
    longDescription = ''
      FediFetcher is a tool for Mastodon that automatically fetches missing
      replies and posts from other fediverse instances, and adds them to your
      own Mastodon instance.
    '';
    homepage = "https://blog.thms.uk/fedifetcher";
    license = licenses.mit;
    maintainers = with maintainers; [ delroth ];
    mainProgram = "fedifetcher";
  };
}
