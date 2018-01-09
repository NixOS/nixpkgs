{ stdenv, buildGoPackage, fetchFromGitHub, git, gnupg, makeWrapper }:

buildGoPackage rec {
  version = "1.6.7";
  name = "gopass-${version}";

  goPackagePath = "github.com/justwatchcom/gopass";

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = "gopass";
    rev = "v${version}";
    sha256 = "0al2avdvmnnz7h21hnvlacr20k50my5l67plgf4cphy52p9461vp";
  };

  wrapperPath = with stdenv.lib; makeBinPath ([
    git
    gnupg
  ]);

  postFixup = ''
    wrapProgram $bin/bin/gopass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = with stdenv.lib; {
    description     = "The slightly more awesome Standard Unix Password Manager for Teams. Written in Go.";
    homepage        = https://github.com/justwatchcom/gopass;
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
