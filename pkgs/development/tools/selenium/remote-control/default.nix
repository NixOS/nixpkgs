args: with args;
stdenv.mkDerivation {
  name = "selenium-rc-0.8.3-binary";

  src = fetchurl {
    url = http://release.openqa.org/cgi-bin/selenium-remote-control-redirect.zip;
    sha256 = "694b46a8440011bcedc4fdc6d01fd91c8b4b4b62b7c6629ace4e745ef47f583e";
  };

  phases = "installPhase";
  installPhase = "
  ensureDir \$out/lib
  cp selenium-server-*/*.jar \$out/lib
  ";

  buildInputs = [unzip];

  meta = { 
      description = "test tool for web applications";
      homepage = http://www.openqa.org/selenium-c;
      license = "";
  };
}
