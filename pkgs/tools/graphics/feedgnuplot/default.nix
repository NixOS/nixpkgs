{ stdenv, fetchFromGitHub, makeWrapper, gawk
, makeFontsConf, freefont_ttf, gnuplot, perl, perlPackages
}:

let

  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };

in

perlPackages.buildPerlPackage rec {
  name = "feedgnuplot-${version}";
  version = "1.51";

  src = fetchFromGitHub {
    owner = "dkogan";
    repo = "feedgnuplot";
    rev = "v${version}";
    sha256 = "0npk2l032cnmibjj5zf3ii09mpxciqn32lx6g5bal91bkxwn7r5i";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ makeWrapper gawk ];

  buildInputs = [ gnuplot perl ]
    ++ (with perlPackages; [ ListMoreUtils IPCRun StringShellQuote ]);

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = fontsConf;

  postPatch = ''
    patchShebangs .
  '';

  # Tests require gnuplot 4.6.4 and are completely skipped with gnuplot 5.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/feedgnuplot \
        --prefix "PATH" ":" "$PATH" \
        --prefix "PERL5LIB" ":" "$PERL5LIB"
    install -D -m 444 -t $out/share/bash-completion/completions \
        completions/bash/feedgnuplot
    install -D -m 444 -t $out/share/zsh/site-functions \
        completions/zsh/_feedgnuplot
  '';

  meta = with stdenv.lib; {
    description = "General purpose pipe-oriented plotting tool";
    homepage = https://github.com/dkogan/feedgnuplot/;
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ mnacamura ];
  };
}
