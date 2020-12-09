{ stdenv, fetchFromGitHub, cmake, libyamlcpp, pkgconfig
, smartSupport ? false, libatasmart }:

stdenv.mkDerivation rec {
  pname = "thinkfan";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "vmatare";
    repo = "thinkfan";
    rev = version;
    sha256 = "18vgm5w5pjnpipa34j4x87q10695w2jnqwvc2f027afy7mnzw7kz";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_DOCDIR=share/doc/${pname}"
    "-DUSE_NVML=OFF"
  ] ++ stdenv.lib.optional smartSupport "-DUSE_ATASMART=ON";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libyamlcpp ] ++ stdenv.lib.optional smartSupport libatasmart;

  installPhase = ''
    runHook preInstall

    install -Dm755 {.,$out/bin}/thinkfan

    cd "$NIX_BUILD_TOP"; cd "$sourceRoot" # attempt to be a bit robust
    install -Dm644 {.,$out/share/doc/thinkfan}/README.md
    cp -R examples $out/share/doc/thinkfan
    install -Dm644 {src,$out/share/man/man1}/thinkfan.1

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description  = "A minimalist fan control program";
    longDescription = "A minimalist fan control program. Originally designed
specifically for IBM/Lenovo Thinkpads, it now supports any kind of system via
the sysfs hwmon interface (/sys/class/hwmon).";
    license = licenses.gpl3;
    homepage = "https://github.com/vmatare/thinkfan";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.linux;
  };
}
