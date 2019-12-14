{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, libnotify }:

buildGoPackage rec {
  pname = "powerd";
  version = "1.0.0";

  goPackagePath = "github.com/shizonic/powerd";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "shizonic";
    repo = "powerd";
    rev = version;
    sha256 = "194jjir1clzf6av65f12fi6a2h2g4zz54jbq2hg7hnlzxsd36mjp";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $bin/bin/powerd --prefix PATH : ${libnotify}/bin
  '';

  meta = with stdenv.lib; {
    description = "Simple daemon to handle battery power levels";
    homepage = src.meta.homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
