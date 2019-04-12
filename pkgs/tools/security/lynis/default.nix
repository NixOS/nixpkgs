{ stdenv, makeWrapper, fetchFromGitHub, gawk }:

stdenv.mkDerivation rec {
  pname = "lynis";
  version = "2.7.2";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0dbbfk47dpxx7zpb98n4w3ls3z5di57qnr2nsgxjvp49gk9j3f6k";
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
