{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gotty";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "sorenisanerd";
    repo = "gotty";
    rev = "v${version}";
    sha256 = "sha256-KkFnZ0j6rrzX2M+C0nVdSdta34B9rvL7cC0TOL38lGQ=";
  };

  vendorSha256 = "sha256-6SgF61LW5F/61cB2Yd4cyu3fmFhDooSTw9+NnIAo7lc=";

  # upstream did not update the tests, so they are broken now
  # https://github.com/sorenisanerd/gotty/issues/13
  doCheck = false;

  meta = with lib; {
    description = "Share your terminal as a web application";
    homepage = "https://github.com/sorenisanerd/gotty";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.mit;
  };
}
