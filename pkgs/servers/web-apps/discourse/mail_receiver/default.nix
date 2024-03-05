{ stdenv, lib, fetchFromGitHub, ruby, makeWrapper, replace }:

stdenv.mkDerivation rec {
  pname = "discourse-mail-receiver";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "mail-receiver";
    rev = "v${version}";
    sha256 = "0grifm5qyqazq63va3w26xjqnxwmfixhx0fx0zy7kd39378wwa6i";
  };

  nativeBuildInputs = [ replace makeWrapper ];
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
