{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, gnupg
, perl
}:

let
  perlEnv = perl.withPackages (p: with p; [ TextMarkdown ]);
in
stdenv.mkDerivation rec {
  pname = "regpg";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "fanf2";
    repo = "regpg";
    rev = "regpg-${version}";
    sha256 = "2ea99950804078190e1cc2a76d4740e3fdd5395a9043db3f3fe86bf2477d3a7d";
  };

  nativeBuildInputs = [ makeWrapper perlEnv ];

  postPatch = ''
    patchShebangs ./util/insert-here.pl ./util/markdown.pl
    substituteInPlace ./Makefile \
      --replace 'util/insert-here.pl' 'perl util/insert-here.pl'
    substituteInPlace ./Makefile \
      --replace 'util/markdown.pl' 'perl util/markdown.pl'
    substituteInPlace util/insert-here.pl \
      --replace 'qx(git describe)' '"regpg-${version}"'
  '';

  dontConfigure = true;

  makeFlags = [ "prefix=$(out)" ];

  postFixup = ''
    patchShebangs $out/bin/regpg
    wrapProgram $out/bin/regpg --prefix PATH ":" \
      "${lib.makeBinPath [ gnupg ]}"
  '';

  meta = with lib; {
    description = "GPG wrapper utility for storing secrets in VCS";
    homepage = "https://dotat.at/prog/regpg";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ _0xC45 ];
  };
}
