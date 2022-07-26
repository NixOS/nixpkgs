{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "pgweb";
  version = "0.11.11";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oKUmBrGxExppJ5y4fZOmMOT5XDMsyMvtE9czotdlMPM=";
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

  vendorSha256 = "sha256-Svy0aZKOGL0vrT058szlpS5t7NvzcyRCHRksdmdkckI=";

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
