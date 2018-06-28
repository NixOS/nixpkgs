{ stdenv, makeWrapper, fetchFromGitHub, gawk, perl }:

stdenv.mkDerivation rec {
  pname = "lynis";
  version = "2.6.5";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0q8irq7hmb0nalmc8xn13d08j0qf6sxfiq2c9s7z1c0gd357gmh9";
  };

  nativeBuildInputs = [ makeWrapper perl ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
    # Don't use predefined binary paths. See https://github.com/CISOfy/lynis/issues/468
    perl -i -p0e 's/BIN_PATHS="[^"]*"/BIN_PATHS=\$\(echo \$PATH\ | sed "s\/:\/ \/g")/sm;' include/consts
  '';

  installPhase = ''
    mkdir -p $out/share/lynis
    cp -r include db default.prf $out/share/lynis/
    mkdir -p $out/bin
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
