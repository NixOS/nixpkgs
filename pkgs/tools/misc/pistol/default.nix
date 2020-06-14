{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ar8c7s8ihcwrwfspmqw7cb5560wkbdc5qyvddkx8lj03cjhcslj";
  };

  vendorSha256 = "1mhxb72fzpa2n88i9h154aci346dgcs2njznkjxchivz28crbqr8";

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