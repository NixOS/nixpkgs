{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pass-update";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-update";
    rev = "v${version}";
    sha256 = "sha256-NFdPnGMs8myiHufeHAQUNDUuvDzYeoWYZllI9+4HL+s=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "BASHCOMPDIR ?= /etc/bash_completion.d" "BASHCOMPDIR ?= $out/share/bash-completion/completions"
  '';

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Pass extension that provides an easy flow for updating passwords";
    homepage = "https://github.com/roddhjav/pass-update";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
