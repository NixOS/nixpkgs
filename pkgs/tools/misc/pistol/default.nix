{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x9wb0gj5l71xz15ia0i2hrnhcpf457i21w41jzw2ink2fbdxp3b";
  };

  vendorSha256 = "0dg4f9g6895nv3c6d74ijl6hzsyn620ndspbcq7ynvb1z0hsg6iz";

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  meta = with stdenv.lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
