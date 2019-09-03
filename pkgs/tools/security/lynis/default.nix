{ stdenv, makeWrapper, fetchFromGitHub, gawk }:

stdenv.mkDerivation rec {
  pname = "lynis";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "1lkkbvxm0rgrrlx0szaxmf8ghc3d26wal96sgqk84m37mvs1f7p0";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
  '';

  installPhase = ''
    install -d $out/bin $out/share/lynis/plugins
    cp -r include db default.prf $out/share/lynis/
    cp -a lynis $out/bin
    wrapProgram "$out/bin/lynis" --prefix PATH : ${stdenv.lib.makeBinPath [ gawk ]}
  '';

  meta = with stdenv.lib; {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    homepage = "https://cisofy.com/lynis/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.ryneeverett ];
  };
}
