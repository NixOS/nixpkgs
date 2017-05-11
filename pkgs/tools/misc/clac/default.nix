{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "clac";
  version = "0.0.0.20170416";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    rev = "828600b01e80166bc435d4d73506f0c3e16f2459";
    sha256 = "08fhhvjrc7rn5fjjdqlallr76m6ybj3wm5gx407jbgfbky0fj7mb";
  };

  buildInputs = [];
  makeFlags = ["PREFIX=$(out)"];

  postInstall = ''
    mkdir -p "$out/share/doc/${pname}"
    cp README* LICENSE "$out/share/doc/${pname}"
  '';

  meta = {
    inherit version;
    description = "Interactive stack-based calculator";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://github.com/soveran/clac";
  };
}
