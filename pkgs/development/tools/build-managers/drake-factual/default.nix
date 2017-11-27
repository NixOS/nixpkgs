{ stdenv, leiningen, jdk, which, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "drake";
  numVersion = "1.0.3";
  version = "v${numVersion}";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Factual";
    rev = version;
    sha256 = "0sm8ghw9x7ba05q6c2gx1my46xigw0a0djjdlrqni2jj3pf0v27w";
  };

  buildInputs = [ leiningen ];
  propagatedBuildInputs = [ jdk which ];

  patchPhase = ''
    sed -i -e "1d" bin/drake
  '';

  buildPhase = ''
    chmod +x bin/drake
    sed -ie '/:main drake.core/a \ \ :local-repo ".m2"' project.clj
    bin/drake --version
    mkdir $out
    mkdir $out/target
    mkdir $out/bin
    export DRAKE_HOME=$out
    mv bin/drake $out/bin
    mv target/drake-${numVersion}.jar $out/target
  '';

  phases = [ "unpackPhase" "patchPhase" "configurePhase" "buildPhase" "checkPhase"];

  meta = with stdenv.lib; {
    description = "a simple-to-use, extensible, text-based data workflow tool that organizes command execution around data and its dependencies";
    homepage = https://github.com/Factual/drake;
    license = licenses.epl10;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rybern ];
  };
}
