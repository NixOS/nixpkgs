{ stdenv
, buildGoModule
, fetchFromGitHub
, file
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zxvpmy6c26dhg5wpk5cgaqipw5372crkhm1vaghm8jkiw7sjwvw";
  };

  modSha256 = "13yxcfd29ziprjsjl2ji7w5i2506hwwl3y0ycaphj2wlcd75rdxs";

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
