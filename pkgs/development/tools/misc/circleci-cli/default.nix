{ stdenv, fetchFromGitHub, docker, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "circleci-cli";
  version = "2018-05-12";

  src = fetchFromGitHub {
    owner = "circleci";
    repo = "local-cli";
    rev = "2c7c1a74e3c3ffb8eebc03fccd782b1bfe9e940a";
    sha256 = "0fp0fz0xr7ynp32lqcmaigl9p45wk1hd2gv9i5q5bj9syj3g7qzm";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/bin/"
    cp "$src/circleci.sh" "$out/bin/circleci"
  '';

  postFixup = ''
    wrapProgram $out/bin/circleci \
      --prefix "PATH" : "${docker}/bin"
  '';

  meta = with stdenv.lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://circleci.com/;
  };
}
