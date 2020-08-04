{ stdenv, makeWrapper, fetchFromGitHub, gawk, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "lynis";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = pname;
    rev = version;
    sha256 = "05p8h2ww4jcc6lgxrm796cbvlfmw26rxq5fmw0xxavbpadiw752j";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
  '';

  installPhase = ''
    install -d $out/bin $out/share/lynis/plugins
    cp -r include db default.prf $out/share/lynis/
    cp -a lynis $out/bin
    wrapProgram "$out/bin/lynis" --prefix PATH : ${stdenv.lib.makeBinPath [ gawk ]}

    installManPage lynis.8
    installShellCompletion --bash --name lynis.bash \
      extras/bash_completion.d/lynis
  '';

  meta = with stdenv.lib; {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    homepage = "https://cisofy.com/lynis/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.ryneeverett ];
  };
}
