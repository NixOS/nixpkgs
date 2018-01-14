{ stdenv, fetchFromGitHub, fetchpatch, makeWrapper, binutils-unwrapped }:

stdenv.mkDerivation rec {
  name = "spectre-meltdown-checker-${version}";
  version = "0.29";

  src = fetchFromGitHub {
    owner = "speed47";
    repo = "spectre-meltdown-checker";
    rev = "v${version}";
    sha256 = "14i9gx1ngs3ixjirlx4qd87pmac916rvv9y61a5f7nl0dig4awl4";
  };

  patches = fetchpatch {
    url = "https://github.com/speed47/spectre-meltdown-checker/pull/79.patch";
    sha256 = "185kac5r97s3dnihgpwx4aashnzffb1f09xv9jw409g7i6cv2sq9";
  };

  prePatch = ''
    substituteInPlace spectre-meltdown-checker.sh \
      --replace /bin/echo echo
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
