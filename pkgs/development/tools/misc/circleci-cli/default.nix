{ stdenv, fetchFromGitHub, docker, makeWrapper }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "circleci-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "circleci";
    repo = "local-cli";
    rev = "v${version}";
    sha256 = "1bv1ck5zvyl6pyvbfglizg8ybna4yg2nz441kiv5rmp4g27n6db2";
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
