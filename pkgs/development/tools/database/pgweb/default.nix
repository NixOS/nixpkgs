{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pgweb";
  version = "0.11.12";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5BFTvfTXsz5ZerSoAudavT/C+SA/xkmVBtAOhAixcAE=";
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

  vendorSha256 = "sha256-pXV1BodOEZs5sv7UE/C58SAyIUZW5Cp2gJD7g8EuWog=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A web-based database browser for PostgreSQL";
    longDescription = ''
      A simple postgres browser that runs as a web server. You can view data,
      run queries and examine tables and indexes.
    '';
    homepage = "https://sosedoff.github.io/pgweb/";
    license = licenses.mit;
    maintainers = with maintainers; [ zupo ];
  };
}
