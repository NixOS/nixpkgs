{ lib
, bundlerApp
, bundlerUpdateScript
}:

bundlerApp rec {
  pname = "pru";
  gemdir = ./.;
  exes = [ "pru" ];

  meta = with lib; {
    homepage = "https://github.com/grosser/pru";
    description = "Pipeable Ruby";
    longDescription = ''
      pru allows to use Ruby scripts as filters, working as a convenient,
      higher-level replacement of typical text processing tools (like sed, awk,
      grep etc.).
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };

  passthru.updateScript = bundlerUpdateScript pname;
}
