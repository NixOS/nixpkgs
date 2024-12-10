{
  stdenv,
  lib,
  fetchFromGitHub,
  ruby,
  makeWrapper,
  replace,
}:

stdenv.mkDerivation rec {
  pname = "discourse-mail-receiver";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "mail-receiver";
    rev = "v${version}";
    sha256 = "sha256-ob4Hb88odlFf5vSC9qhikhJowo4C5LksVmMuJRMNoI4=";
  };

  nativeBuildInputs = [
    replace
    makeWrapper
  ];
  buildInputs = [ ruby ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin

    replace-literal -f -r -e /etc/postfix /run/discourse-mail-receiver .

    cp -r receive-mail discourse-smtp-fast-rejection $out/bin/
    cp -r lib $out/

    wrapProgram $out/bin/receive-mail --set RUBYLIB $out/lib
    wrapProgram $out/bin/discourse-smtp-fast-rejection --set RUBYLIB $out/lib
  '';

  meta = with lib; {
    homepage = "https://www.discourse.org/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "A helper program which receives incoming mail for Discourse";
  };

}
