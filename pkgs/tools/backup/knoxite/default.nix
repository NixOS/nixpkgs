{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "knoxite";
  version = "unstable-2020-06-15";

  src = fetchFromGitHub {
    owner = "knoxite";
    repo = pname;
    rev = "bfdf2fab2325fb2e7521fdf32bbb6edbab4c9896";
    sha256 = "0fn0rw7xs1q3ybdcbnwwk61wn326n64085gv6qyrn0267vjrnhwj";
  };

  vendorSha256 = "0cwz0ml384zyq85rln8yi8ymdbc6xb7zy3r2yg135js6r3jjripf";

  meta = with stdenv.lib; {
    description     = "A secure data storage and backup system";
    homepage        = "https://www.knoxite.com";
    license         = licenses.agpl3;
    maintainers     = [ maintainers.penguwin ];
    platforms       = platforms.unix;
  };
}
