{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k6afpazggpd7cabbw6ldv77bjj43083d5diy2w0iq5nw69gmwd3";
  };

  modSha256 = "1fx53df67mq7p3ampr96x8hd99v2991alb16v8iq36f032raa32f";

  meta = with stdenv.lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun ];
    platforms = platforms.all;
  };
}
