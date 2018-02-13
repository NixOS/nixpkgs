{ stdenv, fetchFromGitHub, makeWrapper, coreutils, binutils-unwrapped }:

stdenv.mkDerivation rec {
  name = "spectre-meltdown-checker-${version}";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "v${version}";
    sha256 = "0jlqxzii883yl5iqmywqqqjlhgswn033566a3vpspycj3sr8zrd2";
  };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace /bin/echo ${coreutils}/bin/echo
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = with stdenv.lib; ''
    install -Dt $out/lib spectre-meltdown-checker.sh
    makeWrapper $out/lib/spectre-meltdown-checker.sh $out/bin/spectre-meltdown-checker \
      --prefix PATH : ${makeBinPath [ binutils-unwrapped ]}
  '';

  meta = with stdenv.lib; {
    description = "Spectre & Meltdown vulnerability/mitigation checker for Linux";
    homepage = https://github.com/speed47/spectre-meltdown-checker;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
