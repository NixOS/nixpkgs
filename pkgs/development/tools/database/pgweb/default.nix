{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "pgweb";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = pname;
    rev = "v${version}";
    sha256 = "1df3vixxca80i040apbim80nqni94q882ykn3cglyccyl0iz59ix";
  };

  goPackagePath = "github.com/sosedoff/pgweb";

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
