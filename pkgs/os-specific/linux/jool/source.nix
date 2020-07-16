{ fetchFromGitHub }:

rec {
  version = "4.0.9";
  src = fetchFromGitHub {
    owner = "NICMx";
    repo = "Jool";
    rev = "v${version}";
    sha256 = "0zhdpk1sbsv1iyr9rvj94wk853684avz3zzn4cv2k4254d7n25m7";
  };
}
