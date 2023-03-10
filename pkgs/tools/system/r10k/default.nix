{ lib, bundlerApp, bundlerUpdateScript, makeWrapper, git, gnutar, gzip }:

bundlerApp {
  pname = "r10k";
  gemdir = ./.;
  exes = [ "r10k" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/r10k --prefix PATH : ${lib.makeBinPath [ git gnutar gzip ]}
  '';

  passthru.updateScript = bundlerUpdateScript "r10k";

  meta = with lib; {
    description = "Puppet environment and module deployment";
    homepage    = "https://github.com/puppetlabs/r10k";
    license     = licenses.asl20;
    maintainers = with maintainers; [ zimbatm manveru nicknovitski ];
    platforms = platforms.unix;
  };
}
