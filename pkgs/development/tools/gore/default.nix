{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gore";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "61Hn3Vs4BZtAX8WNJlUeodvEWvwLo+lXKsc8JxRwOE4=";
  };

  vendorSha256 = "3bq6sRKS5dq7WCPpKGm2q5gFajthR3zhrTFGve9zXhY=";

  meta = with stdenv.lib; {
    description = "Yet another Go REPL that works nicely.";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
