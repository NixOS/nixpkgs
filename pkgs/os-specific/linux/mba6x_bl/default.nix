{ fetchFromGitHub, kernel, lib, buildModule }:

buildModule {
  pname = "mba6x_bl";
  version = "unstable-2016-12-08";

  src = fetchFromGitHub {
    owner = "patjak";
    repo = "mba6x_bl";
    rev = "b96aafd30c18200b4ad1f6eb995bc19200f60c47";
    sha256 = "10payvfxahazdxisch4wm29fhl8y07ki72q4c78sl4rn73sj6yjq";
  };

  enableParallelBuilding = true;
  hardeningDisable = [ "pic" ];

  meta = with lib; {
    description = "MacBook Air 6,1 and 6,2 (mid 2013) backlight driver";
    homepage = "https://github.com/patjak/mba6x_bl";
    license = licenses.gpl2;
    maintainers = [ maintainers.simonvandel ];
  };
}
