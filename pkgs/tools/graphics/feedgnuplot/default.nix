{ lib, fetchFromGitHub, makeWrapper
, makeFontsConf, freefont_ttf, gnuplot, perl, perlPackages
, stdenv, shortenPerlShebang
}:

let

  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };

in

perlPackages.buildPerlPackage rec {
  pname = "feedgnuplot";
  version = "1.58";

  src = fetchFromGitHub {
    owner = "dkogan";
    repo = "feedgnuplot";
    rev = "v${version}";
    sha256 = "1qix4lwwyhqibz0a6q2rrb497rmk00v1fvmdyinj0dqmgjw155zr";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;

  buildInputs = [ gnuplot perl ]
    ++ (with perlPackages; [ ListMoreUtils IPCRun StringShellQuote ]);

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = fontsConf;

  postPatch = ''
    patchShebangs .
  '';

  # Tests require gnuplot 4.6.4 and are completely skipped with gnuplot 5.
  doCheck = false;

  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/feedgnuplot
  '' + ''
    wrapProgram $out/bin/feedgnuplot \
        --prefix "PATH" ":" "$PATH" \
        --prefix "PERL5LIB" ":" "$PERL5LIB"
    install -D -m 444 -t $out/share/bash-completion/completions \
        completions/bash/feedgnuplot
    install -D -m 444 -t $out/share/zsh/site-functions \
        completions/zsh/_feedgnuplot
  '';

  meta = with lib; {
    description = "General purpose pipe-oriented plotting tool";
    homepage = "https://github.com/dkogan/feedgnuplot/";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ mnacamura ];
  };
}
