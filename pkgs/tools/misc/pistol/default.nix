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

  vendorSha256 = "1f780vhxw0brvnr8hhah4sf6ms8spar29rqmy1kcqf9m75n94g56";

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