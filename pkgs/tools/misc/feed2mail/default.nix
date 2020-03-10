{ lib, python2Packages, fetchFromGitHub
, configurationString ? null
}:


assert lib.asserts.assertMsg ( configurationString != null )
  "You need to pass a configuration string to the feed2mail  package";

let
  configFile = builtins.toFile "feed2mail-config" configurationString;
in
python2Packages.buildPythonApplication rec {
  pname = "feed2mail";
  version = "2020-03-10";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = "facd4d207bd7332f06b46b59a190710affa6c493";
    sha256 = "0md75l93s03zxza8gmlqa9a9z88474wkk33h84wd7p9f91gvi0k3";
  };

  propagatedBuildInputs = with python2Packages; [ html2text feedparser ];
  installPhase = ''
    mkdir -p $out/bin/

    # hackedy hack
    echo "#!/usr/bin/env python" | cat - feed2mail.py > $out/bin/feed2mail.py
    ln -s ${configFile} $out/bin/config.py

    chmod +x $out/bin/feed2mail.py
  '';

  meta = with lib; {
    homepage = "https://github.com/jonashaag/feed2mail";
    description = "not-that-messy rss2email clone";
    license = licenses.isc;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
