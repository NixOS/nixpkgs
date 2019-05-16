{ bundlerApp, lib, makeWrapper, curl }:

bundlerApp {
  pname = "wpscan";
  gemdir = ./.;
  exes = [ "wpscan" ];

  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/wpscan" \
      --prefix PATH : ${lib.makeBinPath [ curl ]}
  '';

  meta = with lib; {
    description = "Black box WordPress vulnerability scanner";
    homepage    = https://wpscan.org/;
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ nyanloutre manveru ];
    platforms   = platforms.unix;
  };
}
