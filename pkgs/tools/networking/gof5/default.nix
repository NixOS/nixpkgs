{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gof5";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "kayrus";
    repo = pname;
    rev = "v${version}";
    sha256 = "10qh7rj8s540ghjdvymly53vny3n0qd0z0ixy24n026jjhgjvnpl";
  };

  vendorHash = null;

  # The tests are broken and apparently you need to uncomment some lines in the
  # code in order for it to work.
  # See: https://github.com/kayrus/gof5/blob/674485bdf5a0eb2ab57879a32a2cb4bab8d5d44c/pkg/client/http.go#L172-L174
  doCheck = false;

  meta = with lib; {
    description = "Open Source F5 BIG-IP VPN client";
    homepage = "https://github.com/kayrus/gof5";
    license = licenses.asl20;
    maintainers = with maintainers; [ leixb ];
    mainProgram = "gof5";
  };
}
