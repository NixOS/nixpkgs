{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pgweb";
  version = "0.11.11";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = "pgweb";
    rev = "v${version}";
    sha256 = "sha256-oKUmBrGxExppJ5y4fZOmMOT5XDMsyMvtE9czotdlMPM=";
  };

  vendorSha256 = "sha256-Svy0aZKOGL0vrT058szlpS5t7NvzcyRCHRksdmdkckI=";

  ldflags = [ "-s" "-w" ];

  # Tests depend on a PostgreSQL service.
  doCheck = false;

  meta = with lib; {
    description = "A web-based database browser for PostgreSQL";
    longDescription = ''
      A simple postgres browser that runs as a web server. You can view data,
      run queries and examine tables and indexes.
    '';
    homepage = "https://sosedoff.github.io/pgweb";
    changelog = "https://github.com/sosedoff/pgweb/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ zupo ];
  };
}
