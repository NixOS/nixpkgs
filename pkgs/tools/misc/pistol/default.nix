{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d9c1bhidh781dis4427wramfrla4avqw9y2bmpjp81cqq3nc27d";
  };

  modSha256 = "0r062nka72ah2nb2gf8dfrrj4sxadkykcqjzkp4c9vwk93mhw41k";
  buildFlagsArray = [ "-ldflags=-s -w -X main.Version=${version}" ];

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];

  meta = with stdenv.lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
