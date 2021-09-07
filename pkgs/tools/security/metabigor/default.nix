{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "metabigor";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "j3ssie";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gjqjz35m9hj4dpch9akkjs895qrp8fwhcsn474lz6z2q6sb65pr";
  };

  vendorSha256 = "071s3vlz0maz1597l8y899758g24vh58s4kam4q2mxkzfynzs0cr";

  # Disabled for now as there are some failures ("undefined:")
  doCheck = false;

  meta = with lib; {
    description = "Tool to perform OSINT tasks";
    homepage = "https://github.com/j3ssie/metabigor";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
