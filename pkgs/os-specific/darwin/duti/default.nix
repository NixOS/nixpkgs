{stdenv, lib, fetchFromGitHub, autoreconfHook, darwin}:

stdenv.mkDerivation rec {
  pname = "duti";
  version = "1.5.4pre";
  src = fetchFromGitHub {
    owner = "moretension";
    repo = pname;
    rev = "7dbcae86f99fedef5a6c4311f032a0f1ca0539cc";
    sha256 = "1z9sa0yk87vs57d5338y6lvm1v1vvynxb7dy1x5aqzkcr0imhljl";
  };
  nativeBuildInputs = [autoreconfHook];
  buildInputs = [darwin.apple_sdk.frameworks.ApplicationServices];
  configureFlags = ["--with-macosx-sdk=/homeless-shelter"];
  meta = with lib; {
    description = "A command-line tool to select default applications for document types and URL schemes on Mac OS X";
    longDescription = ''
      duti is a command-line utility capable of setting default applications for
      various document types on Mac OS X, using Apple's Uniform Type Identifiers. A
      UTI is a unique string describing the format of a file's content. For instance,
      a Microsoft Word document has a UTI of com.microsoft.word.doc. Using duti, the
      user can change which application acts as the default handler for a given UTI.
    '';
    maintainers = with maintainers; [matthewbauer];
    platforms = platforms.darwin;
    license = licenses.publicDomain;
    homepage = "http://duti.org/";
  };
}
