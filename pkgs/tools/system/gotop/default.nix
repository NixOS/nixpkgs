{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotop";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m1a5bdqjgsm9fy3d2c6r4nil013cizqyqf19k6r4p9bq8rajnzp";
  };

  vendorSha256 = "1pxp0a1hldkdmh174adhq8q0wyz005g7wm8yxknchvp7krxi9r0v";

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}