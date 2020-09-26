{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q5mgqxg2p87dc42lgpkg94c1q32kssf15qpvr68c254ihghx6kp";
  };

  vendorSha256 = "1sfgr5ih12xq9nsjw952wzm9yc7140cbhcwm1ikdq495kz8mfqx2";

  doCheck = false;

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
