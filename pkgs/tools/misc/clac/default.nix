{stdenv, fetchFromGitHub}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "clac";
  version = "0.0.0.20170503";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    rev = "e92bd5cbab0d694cef945e3478820c9505e06f04";
    sha256 = "0j8p1npgq32s377c9lw959h5i2csq4yb27cvg7av17bji46816bv";
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
