{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pass-update";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-update";
    rev = "v${version}";
    sha256 = "0yx8w97jcp6lv7ad5jxqnj04csbrn2hhc4pskssxknw2sbvg4g6c";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "BASHCOMPDIR ?= /etc/bash_completion.d" "BASHCOMPDIR ?= $out/etc/bash_completion.d"
  '';

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Pass extension that provides an easy flow for updating passwords";
    homepage = https://github.com/roddhjav/pass-update;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 the-kenny fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
