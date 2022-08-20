{ lib, buildGoModule, fetchFromSourcehut }:

buildGoModule rec {
  pname = "alps";
  version = "2022-06-03";

  src = fetchFromSourcehut {
    owner = "~migadu";
    repo = "alps";
    rev = "9cb23b09975e95f6a5952e3718eaf471c3e3510f";
    hash = "sha256-BUV1/BRIXHEf2FU1rdmNgueo8KSUlMKbIpAg2lFs3hA=";
  };

  vendorSha256 = "sha256-cpY+lYM/nAX3nUaFknrRAavxDk8UDzJkoqFjJ1/KWeg=";

  ldflags = [
    "-X main.themesPath=${placeholder "out"}/share/alps/themes"
    "-X git.sr.ht/~migadu/alps.PluginDir=${placeholder "out"}/share/alps/plugins"
  ];

  postPatch = ''
    substituteInPlace plugin.go --replace "const PluginDir" "var PluginDir"
  '';

  postInstall = ''
    mkdir -p "$out/share/alps"
    cp -r themes plugins "$out/share/alps/"
  '';

  proxyVendor = true;

  meta = with lib; {
    description = "A simple and extensible webmail.";
    homepage = "https://git.sr.ht/~migadu/alps";
    license = licenses.mit;
    maintainers = with maintainers; [ gordias booklearner ];
  };
}
