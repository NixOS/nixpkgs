{ lib
, fetchurl
, stdenvNoCC
, coreutils
, bash
, binSh ? "${bash}/bin/bash"
, gnused
, less
}:

stdenvNoCC.mkDerivation rec {
  pname = "colorless";
  version = "109";

  src = fetchurl {
    url = "http://software.kimmo.suominen.com/${pname}-${version}.tar.gz";
    sha256 = "039a140fa11cf153cc4d03e4f753b7ff142cab88ff116b7600ccf9edee81927c";
  };

  makeFlags = [
    "TOOLPATH=${lib.makeBinPath [ coreutils gnused less ]}"
    "PREFIX=$(out)"
    "SHELL=${binSh}"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  postInstall = ''
    install -Dm644 -t $out/share/doc/colorless LICENSE README.md
  '';

  strictDeps = true;

  meta = with lib; {
    homepage = "https://kimmo.suominen.com/sw/colorless";
    description = "Enable colorised command output and pipe it to less";
    longDescription = ''
      colorless is a wrapper that enables colorised output of commands and
      pipes the output to less(1).
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ suominen ];
    platforms = platforms.unix;
    mainProgram = "colorless";
  };
}
