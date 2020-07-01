{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.3.0";

  goPackagePath = "github.com/securego/gosec";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z782rr4z0nhlj6cmjd17pbi65zabpmb83mv4y93wi4qa7kkpm2g";
  };

  vendorSha256 = "0zrmhqcid8xr6i1xxg3s8sll8a667w2vmn5asdw0b43k6k3h941p";

  meta = with stdenv.lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

