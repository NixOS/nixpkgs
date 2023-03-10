{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "1.16.2";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "v${version}";
    sha256 = "sha256-5hjAP2+0hbYcA9G7YJyRqqp1ZC8LzFDomjeFjl4z4FY=";
  };

  vendorHash = "sha256-7fC1jJMY/XK+GX5t2/o/k+EjFxAlRAmiemMcWaZhL9o=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
  };
}
