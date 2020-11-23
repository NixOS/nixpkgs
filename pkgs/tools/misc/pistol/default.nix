{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kspix7ac4fb0gblrlhnf8hi2ijc997qqkhmy47jibmj6120lmqk";
  };

  vendorSha256 = "08fjavadx5mwibzc130mlhp4zph6iwv15xnd4rsniw6zldkzmczy";

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
