{ stdenv, appleDerivation, xcbuildHook, gnumake, Security
, libsecurity_utilities, libsecurity_cdsa_utilities }:

appleDerivation {
  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ libsecurity_utilities libsecurity_cdsa_utilities ];

  DSTROOT = "$out";

  NIX_CFLAGS_COMPILE = "-I.";
  preBuild = ''
    mkdir -p Security
    cp ${Security}/Library/Frameworks/Security.framework/Headers/*.h Security
  '';

  patchPhase = ''
    substituteInPlace SmartCardServices.xcodeproj/project.pbxproj \
      --replace "/usr/bin/gnumake" "${gnumake}/bin/make"
    substituteInPlace src/PCSC/PCSC.exp \
      --replace _PCSCVersionString "" \
      --replace _PCSCVersionNumber ""
    substituteInPlace Makefile.installPhase \
      --replace chown "# chown" \
      --replace /usr/bin/ ""
  '';

  installPhase = ''
    make -f Makefile.installPhase install
    make -f Makefile-exec.installPhase install
    mv $out/usr/* $out
    rmdir $out/usr

    mkdir -p $out/Library/Frameworks
    cp -r Products/Release/PCSC.bundle $out/Library/Frameworks/PCSC.framework
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ matthewbauer ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}
