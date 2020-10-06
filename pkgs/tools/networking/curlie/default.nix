{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "curlie";
  version = "1.5.4";

  src= fetchFromGitHub {
    owner = "rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z92gz39m0gk8j7l2nwa5vrfr3mq160vr1b15sy13jwi1zspc7hx";
  };

  vendorSha256 = "1qnl15b9cs6xi8z368a9n34v3wr2adwp376cjzhyllni7sf6v1mm";

  doCheck = false;

  meta = with lib; {
    description = "Curlie is a frontend to curl that adds the ease of use of httpie, without compromising on features and performance";
    homepage = "https://curlie.io/";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.mit;
  };
}
