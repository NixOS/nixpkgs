{ lib, stdenv, fetchFromGitHub
, cmake
}:
stdenv.mkDerivation rec {
  pname = "bento4";
<<<<<<< HEAD
  version = "1.6.0-640";
=======
  version = "1.6.0-639";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "axiomatic-systems";
    repo = "Bento4";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VhlFfNYw3xpAIyWqDyhgXIv3JtpFJH0BL97dFX8diRY=";
=======
    sha256 = "sha256-Rfmyjsgn/dcIplRtPFb5AfBxWOKmP6w8IHykgVxVNsQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./libap4.patch # include all libraries as shared, not static
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib,bin}
<<<<<<< HEAD
    find -iname '*${stdenv.hostPlatform.extensions.sharedLibrary}' -exec mv --target-directory="$out/lib" {} \;
=======
    find -iname '*.so' -exec mv --target-directory="$out/lib" {} \;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    find -maxdepth 1 -executable -type f -exec mv --target-directory="$out/bin" {} \;
    runHook postInstall
  '';

<<<<<<< HEAD
  # Patch binaries to use our dylib
  postInstall = lib.optionalString stdenv.isDarwin ''
    find $out/bin -maxdepth 1 -executable -type f -exec install_name_tool -change @rpath/libap4.dylib $out/lib/libap4.dylib {} \;
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Full-featured MP4 format and MPEG DASH library and tools";
    homepage = "http://bento4.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ makefu ];
<<<<<<< HEAD
=======
    broken = stdenv.isAarch64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}
