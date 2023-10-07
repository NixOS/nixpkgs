{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "confluencepot";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "SIFalcon";
    repo = "confluencePot";
    rev = "v${version}";
    hash = "sha256-jIbL6prOUII8o9FghIYa80BytJ9SSuyj/TZmAxwAbJk=";
  };

  vendorHash = "sha256-nzPHx+c369T4h9KETqMurxZK3LsJAhwBaunkcWIW3Ps=";

  postPatch = ''
    substituteInPlace confluencePot.go \
      --replace "confluence.html" "$out/share/confluence.html"
  '';

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/confluencePot $out/bin/${pname}
  '';

  preFixup = ''
    # Install HTML file
    install -vD confluence.html -t $out/share
  '';

  meta = with lib; {
    description = "Honeypot for the Atlassian Confluence OGNL injection vulnerability";
    homepage = "https://github.com/SIFalcon/confluencePot";
    longDescription = ''
      ConfluencePot is a simple honeypot for the Atlassian Confluence unauthenticated
      and remote OGNL injection vulnerability (CVE-2022-26134).
    '';
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
