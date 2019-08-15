{ stdenv, buildGoModule, fetchFromGitHub
, git, gnupg
, wl-clipboard, xclip
, makeWrapper }:

buildGoModule rec {
  pname = "gopass";
  version = "8c7b4a250052d401722b6cbf9308b23a3d3d5661";
  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass";
    rev = version;
    sha256 = "1n1xrswypl30vqppw85jsnl412cgpwch35npgsbakkm2lr4z8qja";
  };

  goPackagePath = "github.com/gopasspw/gopass";
  modSha256 = "0ijj5sc2q9fx94slxxzqnx97f833pk48a0jfvq9dk9y9biszf2q4";

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "PREFIX=${placeholder ''out''}"
  ];
  
  wrapperPath = with stdenv.lib; makeBinPath ([
    git
    gnupg
    xclip
  ] ++ stdenv.lib.optional stdenv.isLinux wl-clipboard);

  postFixup = ''
    wrapProgram $out/bin/gopass \
      --prefix PATH : "${wrapperPath}"
  '';

  # Use makefile installPhase for completions
  installPhase = null;

  meta = with stdenv.lib; {
    description     = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go.";
    homepage        = https://www.gopass.pw/;
    license         = licenses.mit;
    maintainers     = with maintainers; [ andir ];
    platforms       = platforms.unix;

    longDescription = ''
      gopass is a rewrite of the pass password manager in Go with the aim of
      making it cross-platform and adding additional features. Our target
      audience are professional developers and sysadmins (and especially teams
      of those) who are well versed with a command line interface. One explicit
      goal for this project is to make it more approachable to non-technical
      users. We go by the UNIX philosophy and try to do one thing and do it
      well, providing a stellar user experience and a sane, simple interface.
    '';
  };
}
