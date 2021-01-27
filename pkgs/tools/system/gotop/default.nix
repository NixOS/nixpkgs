{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotop";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    sha256 = "09cs97fjjxcjxzsl2kh8j607cs5zy2hnrh1pb21pggzhg7dzsz0w";
  };

  runVend = true;
  vendorSha256 = "1mbjl7b49naaqkr2j658j17z9ryf5g3x6q34gvmrm7n9y082ggnz";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    changelog = "https://github.com/xxxserxxx/gotop/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
