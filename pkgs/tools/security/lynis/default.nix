{ lib, stdenv, makeWrapper, fetchFromGitHub, gawk, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "lynis";
<<<<<<< HEAD
  version = "3.0.9";
=======
  version = "3.0.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CISOfy";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Qf5YVvsw4o2ZS3KjrHPJt8+iPr7G97egdDRN+peL8eU=";
=======
    sha256 = "sha256-fPQX/Iz+dc3nF3xMPt0bek4JC2XSHe4aC4O0tZwLf6Y=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postPatch = ''
    grep -rl '/usr/local/lynis' ./ | xargs sed -i "s@/usr/local/lynis@$out/share/lynis@g"
  '';

  installPhase = ''
    install -d $out/bin $out/share/lynis/plugins
    cp -r include db default.prf $out/share/lynis/
    cp -a lynis $out/bin
    wrapProgram "$out/bin/lynis" --prefix PATH : ${lib.makeBinPath [ gawk ]}

    installManPage lynis.8
    installShellCompletion --bash --name lynis.bash \
      extras/bash_completion.d/lynis
  '';

  meta = with lib; {
    description = "Security auditing tool for Linux, macOS, and UNIX-based systems";
    homepage = "https://cisofy.com/lynis/";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ryneeverett ];
  };
}
