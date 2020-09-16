{ stdenv, fetchFromGitHub, libX11, libXdamage, libXrender, libXcomposite, libXext, installShellFiles, git }:

stdenv.mkDerivation rec {
  pname = "find-cursor";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "find-cursor";
    rev = "v${version}";
    sha256 = "13lpcxklv9ayqapyk9pmwxkinhxah5hkr6n0jc2m5hm68nh220w1";
  };

  nativeBuildInputs = [ installShellFiles git ];
  buildInputs = [ libX11 libXdamage libXrender libXcomposite libXext ];
  preInstall = "mkdir -p $out/share/man/man1";
  installFlags = "PREFIX=${placeholder "out"}";

  meta = with stdenv.lib; {
    description = "Simple XLib program to highlight the cursor position";
    homepage = "https://github.com/arp242/find-cursor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.yanganto ];
  };
}
